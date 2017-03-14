//
//  AXAlertView.m
//  AXAlertView
//
//  Created by ai on 16/4/5.
//  Copyright © 2016年 devedbox. All rights reserved.
//

#import "AXAlertView.h"
#import <AXAnimationChain/AXAnimationChain.h>
#import <objc/runtime.h>

@interface AXAlertView () <UIScrollViewDelegate>
{
    NSMutableArray<AXAlertViewAction *> *_actionItems;
    NSArray<__kindof UIButton *> *_actionButtons;
    NSMutableDictionary<NSNumber*,AXAlertViewActionConfiguration*> *_actionConfig;
    
    // Transition view of translucent.
    UIView *__weak _translucentTransitionView;
    
    BOOL _processing;
    UIColor * _backgroundColor;
}
/// Title label.
@property(strong, nonatomic) UILabel *titleLabel;
/// Container view.
@property(strong, nonatomic) UIView *containerView;
/// Content container view.
@property(strong, nonatomic) UIScrollView *contentContainerView;
/// Blur effect view.
@property(strong, nonatomic) UIVisualEffectView *effectView;
@end

@interface AXVisualEffectButton : UIButton
/// Translucent. Defailts to YES.
@property(assign, nonatomic) BOOL translucent;
/// Translucent style. Defaults to Light.
@property(assign, nonatomic) AXAlertViewTranslucentStyle translucentStyle;
/// Blur effect view.
@property(strong, nonatomic) UIVisualEffectView *effectView;
@end

@implementation AXAlertView

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.userInteractionEnabled = YES;
    
    _titleColor = [UIColor colorWithRed:0.996 green:0.725 blue:0.145 alpha:1.00];
    _titleFont = [UIFont boldSystemFontOfSize:17];
    _translucent = YES;
    _hidesOnTouch = NO;
    _contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _titleInset = UIEdgeInsetsMake(10, 10, 0, 10);
    _customViewInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _padding = 10;
    _actionItemPadding = 5;
    _actionItemMargin = 8;
    _horizontalLimits = 2;
    _dimBackground = YES;
    _opacity = 0.4;
    _preferedHeight = .0;
    _preferedMargin = 40;
    _cornerRadius = 6;
    _actionConfiguration = [[AXAlertViewActionConfiguration alloc] init];
    _actionConfiguration.backgroundColor = [UIColor colorWithRed:0.996 green:0.725 blue:0.145 alpha:1.00];
    _actionConfiguration.tintColor = [UIColor whiteColor];
    _actionConfiguration.font = [UIFont boldSystemFontOfSize:15];
    _actionConfiguration.cornerRadius = 4;
    _actionConfiguration.preferedHeight = 44.0;
    _actionConfiguration.translucent = YES;
    
    super.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.contentContainerView];
    [self.containerView addSubview:self.titleLabel];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
#pragma mark - Override
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (_processing) return self;
    return [super hitTest:point withEvent:event];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self configureActions];
        [self configureCustomView];
        
        [self setTranslucent:_translucent];
    } else {
        // Ensure remove the translucent transition view from super view.
        [_translucentTransitionView removeFromSuperview];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    // Call SUPER.
    [super layoutSubviews];
    // Get the current frame of SELF.
    CGRect currentFrame = self.frame;
    // Initialize a CGSize struct of custom view and title label using the current frame and prefered magin and the insets.
    CGSize sizeOfCustomView = CGSizeMake(CGRectGetWidth(currentFrame)-_preferedMargin*2 - (_contentInset.left+_contentInset.right)-(_customViewInset.left+_customViewInset.right), 0);
    CGSize sizeOfTitleLabel = CGSizeMake(CGRectGetWidth(currentFrame)-_preferedMargin*2 - (_contentInset.left+_contentInset.right)-(_titleInset.left+_titleInset.right), 0);
    // Calculate size of title label.
    if (_titleLabel.numberOfLines == 1) {// If number of lines of the title label.
        // Size to fit text content.
        [_titleLabel sizeToFit];
        // Set height of the title label.
        sizeOfTitleLabel.height = _titleLabel.bounds.size.height;
    } else {// Or calculate the size using the TextKit.
        // Calculate size.
        CGSize size = [_titleLabel.text boundingRectWithSize:CGSizeMake(sizeOfTitleLabel.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLabel.font} context:NULL].size;
        // Set height of size.
        sizeOfTitleLabel.height = ceil(size.height);
    }
    // Height of the title label will only be allowed to half of height of SELF.
    sizeOfTitleLabel.height = MIN(sizeOfTitleLabel.height, CGRectGetHeight(currentFrame)*.5);
    // Calculate size of the custom view.
    if ([_customView isKindOfClass:UILabel.class]) {// For the case of custom view is being a kind of UILabel.
        // Calculte the size of label.
        UILabel *label = (UILabel *)_customView;
        // Using bounding rect way.
        CGSize size = [label.text boundingRectWithSize:CGSizeMake(sizeOfCustomView.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:NULL].size;
        // Set height of size.
        sizeOfCustomView.height = ceil(size.height)+_customViewInset.top+_customViewInset.bottom;
    } else {// Size to fit content whatever it is.
        // Size that fit the width of SELF.
        [_customView sizeToFit];
        // Set height of size.
        sizeOfCustomView.height = _customView.bounds.size.height+_customViewInset.top+_customViewInset.bottom;
    }
    // Plus all the heights and paddings adding to a total height of container view.
    CGFloat heightOfContainer = .0;
    heightOfContainer += _contentInset.top;
    if (_titleLabel.text.length > 0) {
        heightOfContainer += _titleInset.top;
        heightOfContainer += sizeOfTitleLabel.height;
        heightOfContainer += _titleInset.bottom;
        heightOfContainer += _padding;
    }
    heightOfContainer += sizeOfCustomView.height;
    // Plus all the heights of the action items ignoring the paddings.
    CGFloat heightOfItems = .0;
    
    if (_actionItems.count > _horizontalLimits) {
        for (int i = 0; i < _actionItems.count; i++) {
            AXAlertViewActionConfiguration *config = _actionConfig[@(i)]?:_actionConfiguration;
            if (config) {
                if (i == 0) {
                    heightOfContainer += _padding;
                } else {
                    heightOfContainer += _actionItemPadding;
                }
                heightOfContainer += config.preferedHeight;
                heightOfItems += config.preferedHeight;
            }
        }
    } else {
        CGFloat maxHeightOfItem = .0;
        for (int i = 0; i < _actionItems.count; i++) {
            AXAlertViewActionConfiguration *config = _actionConfig[@(i)]?:_actionConfiguration;
            if (config) {
                maxHeightOfItem = MAX(maxHeightOfItem, config.preferedHeight);
                heightOfItems = maxHeightOfItem;
            }
        }
        heightOfContainer += _padding;
        heightOfContainer += maxHeightOfItem;
    }
    heightOfContainer += _contentInset.bottom;
    
    heightOfContainer = MAX(heightOfContainer, _preferedHeight);
    
    // Frame of container view.
    CGRect rect_container = _containerView.frame;
    rect_container.origin.x = _preferedMargin;
    
    if (heightOfContainer > CGRectGetHeight(currentFrame)-_preferedMargin*2) { // Too large to cut.
        rect_container.origin.y = _preferedMargin;
        rect_container.size = CGSizeMake(CGRectGetWidth(currentFrame)-_preferedMargin*2, CGRectGetHeight(currentFrame)-_preferedMargin*2);
        _containerView.frame = rect_container;
        // Enabled the scroll of the content container view.
        _contentContainerView.scrollEnabled = YES;
        _effectView.frame = CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), heightOfContainer);
    } else {
        rect_container.origin.y = CGRectGetHeight(currentFrame)*.5-MIN(heightOfContainer, CGRectGetHeight(currentFrame)-_preferedMargin*2)*.5;
        rect_container.size = CGSizeMake(CGRectGetWidth(currentFrame)-_preferedMargin*2, MIN(heightOfContainer, CGRectGetHeight(currentFrame)-_preferedMargin*2));
        _containerView.frame = rect_container;
        // Disable the scroll of the content container view.
        _contentContainerView.scrollEnabled = NO;
        _effectView.frame = CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), _contentInset.top+_titleInset.top+sizeOfTitleLabel.height+_titleInset.bottom);
    }
    
    // Frame of title label.
    CGRect rect_title = _titleLabel.frame;
    rect_title.origin.x = _contentInset.left+_titleInset.left;
    rect_title.origin.y = _contentInset.top+_titleInset.top;
    rect_title.size.width = CGRectGetWidth(rect_container)-(_contentInset.left+_contentInset.right)-(_titleInset.left+_titleInset.right);
    rect_title.size.height = sizeOfTitleLabel.height;
    _titleLabel.frame = rect_title;
    
    // Frame of conent container view.
    CGRect rect_content = _contentContainerView.frame;
    rect_content.origin.x = _contentInset.left;
    rect_content.origin.y = CGRectGetMaxY(rect_title) + _titleInset.bottom + _padding;
    rect_content.size.width = CGRectGetWidth(rect_container)-(_contentInset.left+_contentInset.right);
    rect_content.size.height = CGRectGetHeight(rect_container)-sizeOfTitleLabel.height-_contentInset.top-_titleInset.top-_titleInset.bottom-_padding-_contentInset.bottom;
    _contentContainerView.frame = rect_content;
    // Calculate the content size of the content container view.
    _contentContainerView.contentSize = CGSizeMake(CGRectGetWidth(rect_container)-(_contentInset.left+_contentInset.right), heightOfContainer-sizeOfTitleLabel.height-_contentInset.top-_titleInset.top-_titleInset.bottom-_padding-_contentInset.bottom);
    _customView.frame = CGRectMake(_customViewInset.left, _customViewInset.top, sizeOfCustomView.width, sizeOfCustomView.height-(_customViewInset.top+_customViewInset.bottom));
    
    [self setNeedsDisplay];
    [self configureActions];
}
#pragma mark - Public method
- (void)setActions:(AXAlertViewAction *)actions, ... {
    va_list args;
    va_start(args, actions);
    AXAlertViewAction *action;
    _actionItems = [@[] mutableCopy];
    [_actionItems addObject:actions];
    while ((action = va_arg(args, AXAlertViewAction *))) {
        [_actionItems addObject:action];
    }
    va_end(args);
    [self configureActions];
}

- (void)appendActions:(AXAlertViewAction *)actions, ... {
    va_list args;
    va_start(args, actions);
    AXAlertViewAction *action;
    if (!_actionItems) {
        _actionItems = [@[] mutableCopy];
    }
    [_actionItems addObject:actions];
    while ((action = va_arg(args, AXAlertViewAction *))) {
        [_actionItems addObject:action];
    }
    va_end(args);
    [self configureActions];
}

- (void)show:(BOOL)animated {
    [self showInView:[[UIApplication sharedApplication] keyWindow] animated:animated completion:NULL];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    if (_processing) return;
    [view addSubview:self];
    [self viewWillShow:self animated:animated];
    if (animated) [self.containerView.chainAnimator.combineSpring.property(@"transform.scale").fromValue(@1.2).toValue(@1.0).mass(0.5).stiffness(100).damping(20) easeOut];
    self.chainAnimator.basic.property(@"opacity").fromValue(@(.0)).toValue(@(1.0)).duration(animated?0.35:.0).target(self).complete(@selector(_showComplete:)).animate();
    objc_setAssociatedObject(self.containerView.chainAnimator, @selector(_showComplete:), @(animated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (animated) self.containerView.animate();
}

- (void)_showComplete:(AXChainAnimator *)sender {
    [self viewDidShow:self animated:[objc_getAssociatedObject(self.containerView.chainAnimator, _cmd) boolValue]];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated completion:(AXAlertViewShowsBlock)didShow
{
    _didShow = [didShow copy];
    [self showInView:view animated:animated];
}

- (void)hide:(BOOL)animated {
    if (_processing) return;
    [self viewWillHide:self animated:animated];
    objc_setAssociatedObject(self.containerView.chainAnimator, @selector(_hideComplete:), @(animated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.chainAnimator.basic.property(@"opacity").fromValue(@(1.0)).toValue(@(.0)).duration(animated?0.25:.0).target(self).complete(@selector(_hideComplete:)).animate();
}

- (void)_hideComplete:(AXChainAnimator *)sender {
    [self viewDidHide:self animated:[objc_getAssociatedObject(self.containerView.chainAnimator, _cmd) boolValue]];
}

- (void)hide:(BOOL)animated completion:(AXAlertViewShowsBlock)didHide
{
    _didHide = [didHide copy];
    [self hide:animated];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef outterPath = CGPathCreateWithRect(self.frame, nil);
    CGContextAddPath(context, outterPath);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:_opacity].CGColor);
    CGContextFillPath(context);
    CGPathRef innerPath = CGPathCreateWithRoundedRect(self.containerView.frame, _cornerRadius, _cornerRadius, nil);
    CGContextAddPath(context, innerPath);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextFillPath(context);
}
#pragma mark - Getters
- (UIColor *)backgroundColor {
    return _containerView.backgroundColor;
}

- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor colorWithRed:0.996 green:0.725 blue:0.145 alpha:1.00];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return _titleLabel;
}

- (UIView *)containerView {
    if (_containerView) return _containerView;
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _containerView.clipsToBounds = YES;
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = _cornerRadius;
    _containerView.layer.masksToBounds = YES;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return _containerView;
}

- (UIScrollView *)contentContainerView {
    if (_contentContainerView) return _contentContainerView;
    _contentContainerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _contentContainerView.backgroundColor = [UIColor clearColor];
    _contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentContainerView.showsVerticalScrollIndicator = NO;
    _contentContainerView.showsHorizontalScrollIndicator = NO;
    _contentContainerView.alwaysBounceVertical = YES;
    _contentContainerView.delegate = self;
    return _contentContainerView;
}

- (UIVisualEffectView *)effectView {
    if (_effectView) return _effectView;
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    _effectView.frame = self.bounds;
    _effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return _effectView;
}

- (NSString *)title {
    return _titleLabel.text;
}

#pragma mark - Setters
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    _containerView.backgroundColor = backgroundColor;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _containerView.layer.cornerRadius = _cornerRadius;
    _containerView.layer.masksToBounds = YES;
}

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *)configuration forItemAtIndex:(NSUInteger)index {
    if (!_actionConfig) {
        _actionConfig = [@{} mutableCopy];
    }
    [_actionConfig setObject:configuration forKey:@(index)];
    // Update the configuration of the button at indec.
    [self _updateConfigurationOfItemAtIndex:index];
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    [self configureCustomView];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel.textColor = _titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    _titleLabel.font = _titleFont;
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    if (_translucent) {
        [self.containerView insertSubview:self.effectView atIndex:0];
        if (_translucentStyle == AXAlertViewTranslucentDark) {
            _effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else {
            _effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        _effectView.frame = _containerView.bounds;
        _containerView.backgroundColor = [UIColor clearColor];
    } else {
        [_effectView removeFromSuperview];
        _containerView.backgroundColor = _backgroundColor?:[UIColor whiteColor];
    }
    
    [self configureActions];
    [self setNeedsLayout];
}

- (void)setTranslucentStyle:(AXAlertViewTranslucentStyle)translucentStyle {
    _translucentStyle = translucentStyle;
    
    [self setTranslucent:_translucent];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsLayout];
    [self configureActions];
    [self configureCustomView];
}

- (void)setCustomViewInset:(UIEdgeInsets)customViewInset {
    _customViewInset = customViewInset;
    [self configureCustomView];
}

- (void)setTitleInset:(UIEdgeInsets)titleInset {
    _titleInset = titleInset;
    [self setNeedsLayout];
}

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    [self setNeedsLayout];
    [self configureActions];
    [self configureCustomView];
}

- (void)setActionItemMargin:(CGFloat)actionItemMargin {
    _actionItemMargin = actionItemMargin;
    [self setNeedsLayout];
    [self configureActions];
    [self configureCustomView];
}

- (void)setActionItemPadding:(CGFloat)actionItemPadding {
    _actionItemPadding = actionItemPadding;
    [self setNeedsLayout];
    [self configureActions];
    [self configureCustomView];
}

- (void)setHorizontalLimits:(NSInteger)horizontalLimits {
    _horizontalLimits = horizontalLimits;
    [self configureActions];
}

- (void)setDimBackground:(BOOL)dimBackground {
    _dimBackground = dimBackground;
    /*
    if (dimBackground) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
     */
}

- (void)setOpacity:(CGFloat)opacity {
    _opacity = opacity;
    [self setNeedsDisplay];
}

- (void)setPreferedHeight:(CGFloat)preferedHeight {
    _preferedHeight = preferedHeight;
    [self setNeedsLayout];
    [self configureActions];
    [self configureCustomView];
}

- (void)setPreferedMargin:(CGFloat)preferedMargin {
    _preferedMargin = preferedMargin;
    [self setNeedsLayout];
    [self configureActions];
    [self configureCustomView];
}

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *)actionConfiguration {
    _actionConfiguration = actionConfiguration;
    [self configureActions];
}

#pragma mark - Actions
- (void)handleDeviceOrientationDidChangeNotification:(NSNotification *)aNote {
    [self layoutSubviews];
    [self configureActions];
}

- (void)handleActionButtonDidClick:(UIButton *_Nonnull)sender {
    [self hide:YES];
    AXAlertViewAction *action = _actionItems[sender.tag-1];
    if (action.handler) {
        __weak typeof(action) weakRef = action;
        action.handler(weakRef);
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    if (_touch != NULL && _touch != nil) {
        _touch(self);
    }
    CGPoint point = [tap locationInView:self];
    if (CGRectContainsRect(self.containerView.frame, CGRectMake(point.x, point.y, 1, 1)) || !_hidesOnTouch) {
        return;
    }
    [self hide:YES];
}
#pragma mark - Public
- (void)viewWillShow:(AXAlertView *)alertView animated:(BOOL)animated {
    // Set container view to clear background color of translucent.
    if (self.translucent) self.containerView.backgroundColor = [UIColor clearColor];
    
    [self.layer removeAllAnimations];
    [self.containerView.layer removeAllAnimations];
    
    _processing = YES;
    
    [self layoutSubviews];
    
#if !TARGET_IPHONE_SIMULATOR
    if (_translucent) {
        // Get the current translucent transition view.
        UIView *snapshot = [self.window resizableSnapshotViewFromRect:self.containerView.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        [snapshot setFrame:self.containerView.bounds];
        [self.containerView addSubview:snapshot];
        // Remove the former from the container view if exits.
        if (_translucentTransitionView.superview == self.containerView) {
            [_translucentTransitionView removeFromSuperview];
        }
        _translucentTransitionView = snapshot;
    }
#endif
    
    if (_willShow != NULL && _willShow != nil) {
        _willShow(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillShow:)]) {
        [_delegate alertViewWillShow:self];
    }
}

- (void)viewDidShow:(AXAlertView *)alertView animated:(BOOL)animated {
    [self.layer removeAllAnimations];
    [self.containerView.layer removeAllAnimations];
    // Remove translucent view from container view.
    [_translucentTransitionView removeFromSuperview];
    
    _processing = NO;
    
    if (_didShow != NULL && _didShow != nil) {
        _didShow(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidShow:)]) {
        [_delegate alertViewDidShow:self];
    }
}

- (void)viewWillHide:(AXAlertView *)alertView animated:(BOOL)animated {
    [self.layer removeAllAnimations];
    [self.containerView.layer removeAllAnimations];
    // Remove the former from the container view if exits.
    if (_translucentTransitionView.superview == self.containerView) {
        [_translucentTransitionView removeFromSuperview];
    }
    /*
    if (_translucent) {
        // Get the current translucent transition view.
        UIView *snapshot = [self.window resizableSnapshotViewFromRect:self.containerView.frame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        [snapshot setFrame:self.containerView.bounds];
        [self.containerView addSubview:snapshot];
        // Remove the former from the container view if exits.
        if (_translucentTransitionView.superview == self.containerView) {
            [_translucentTransitionView removeFromSuperview];
        }
        _translucentTransitionView = snapshot;
    }
    */
    if (_willHide != NULL && _willHide != nil) {
        _willHide(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillHide:)]) {
        [_delegate alertViewWillHide:self];
    }
}

- (void)viewDidHide:(AXAlertView *)alertView animated:(BOOL)animated {
    [self removeFromSuperview];
    [self.layer removeAllAnimations];
    [self.containerView.layer removeAllAnimations];
    [_translucentTransitionView removeFromSuperview];
    
    _processing = NO;
    
    if (_didHide != NULL && _didHide != nil) {
        _didHide(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidHide:)]) {
        [_delegate alertViewDidHide:self];
    }
}

#pragma mark - Private

- (void)_updateConfigurationOfItemAtIndex:(NSUInteger)index {
    // Get the button item from the content container view.
    AXVisualEffectButton *buttonItem = [_contentContainerView viewWithTag:index+1];
    // Get the configuration of the configs.
    AXAlertViewActionConfiguration *config = _actionConfig[@(index)];
    // Setup button with configuration.
    [self _setupButtonItem:&buttonItem withConfiguration:config];
}

- (void)configureCustomView {
    if (!self.customView) {
        return;
    }
    [_contentContainerView addSubview:_customView];
    [self setNeedsLayout];
}

- (void)configureActions {
    for (NSInteger i = 0; i < _actionButtons.count; i ++) {
        [_actionButtons[i] removeFromSuperview];
    }
    _actionButtons = [self buttonsWithActions:_actionItems];
    if (_actionButtons.count == 0) return;
    if (_actionButtons.count > _horizontalLimits) {
        for (NSInteger i = 0; i < _actionButtons.count ; i++) {
            UIButton *button = _actionButtons[i];
            button.tag = i+1;
            [button addTarget:self action:@selector(handleActionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            AXAlertViewActionConfiguration *config = _actionConfig[@(i)]?:_actionConfiguration;
            CGFloat beginContext = .0;
            if (i == 0) {
                beginContext = CGRectGetMaxY(_customView.frame) + _padding;
            } else {
                UIButton *lastItem = _actionButtons[i-1];
                beginContext = CGRectGetMaxY(lastItem.frame) + _actionItemPadding;
            }
            [button setFrame:CGRectMake(_actionItemMargin, beginContext, CGRectGetWidth(_contentContainerView.frame)-_actionItemMargin*2, config.preferedHeight)];
            [self.contentContainerView addSubview:button];
        }
    } else {
        CGFloat buttonWidth = (CGRectGetWidth(_contentContainerView.frame)-_actionItemMargin*2-_actionItemPadding*(_actionButtons.count-1))/_actionButtons.count;
        for (NSInteger i = 0; i < _actionButtons.count; i++) {
            UIButton *button = _actionButtons[i];
            button.tag = i+1;
            AXAlertViewActionConfiguration *config = _actionConfig[@(i)]?:_actionConfiguration;
            [button addTarget:self action:@selector(handleActionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(_actionItemMargin+(buttonWidth+_actionItemPadding)*i, CGRectGetMaxY(_customView.frame)+_padding, buttonWidth, config.preferedHeight)];
            [self.contentContainerView addSubview:button];
        }
    }
}

- (NSArray<AXVisualEffectButton*> *_Nonnull)buttonsWithActions:(NSArray<AXAlertViewAction*> *_Nonnull)actions {
    NSMutableArray *buttons = [@[] mutableCopy];
    for (NSInteger i = 0; i < actions.count; i++) {
        AXVisualEffectButton *button = [AXVisualEffectButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[actions[i] title] forState:UIControlStateNormal];
        [button setImage:[actions[i] image] forState:UIControlStateNormal];
        
        AXAlertViewActionConfiguration *config = [_actionConfig objectForKey:@(i)];
        [self _setupButtonItem:&button withConfiguration:config];
        
        [buttons addObject:button];
    }
    return buttons;
}

- (void)_setupButtonItem:(AXVisualEffectButton **)button withConfiguration:(AXAlertViewActionConfiguration *)config {
    if (!config) {
        config = _actionConfiguration;
    }
    UIColor *backgroundColor = config.backgroundColor?config.backgroundColor:_actionConfiguration.backgroundColor;
    if (!backgroundColor) {
        backgroundColor = [self window].tintColor;
    }
    if (!config.translucent || !_translucent) {
        [*button setBackgroundImage:[self rectangleImageWithColor:backgroundColor size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        [*button setBackgroundImage:[self rectangleImageWithColor:[backgroundColor colorWithAlphaComponent:0.8] size:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
    } else {
        [*button setBackgroundImage:[self rectangleImageWithColor:[backgroundColor colorWithAlphaComponent:0.0] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        [*button setBackgroundImage:[self rectangleImageWithColor:[backgroundColor colorWithAlphaComponent:0.3] size:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
    }
    /*
     [(*button) setBackgroundImage:[self rectangleImageWithColor:_translucent?[backgroundColor colorWithAlphaComponent:0.8]:[backgroundColor colorWithAlphaComponent:0.9] size:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
     if (!config.translucent || !_translucent) [(*button) setBackgroundImage:[self rectangleImageWithColor:[UIColor grayColor] size:CGSizeMake(10, 10)] forState:UIControlStateDisabled];
     */
    [*button setBackgroundColor:[UIColor clearColor]];
    [(*button).titleLabel setFont:config.font?config.font:_actionConfiguration.font];
    UIColor *tintColor = config.tintColor?config.tintColor:_actionConfiguration.tintColor;
    if (!tintColor) {
        tintColor = [[self window] tintColor];
    }
    /* Fixed the bug that cannot change the tint color of the custom style button.
    [*button setTintColor:tintColor]; */
    [(*button) setTitleColor:tintColor forState:UIControlStateNormal];
    (*button).layer.cornerRadius = config.cornerRadius;
    (*button).layer.masksToBounds = YES;
    
    (*button).translucent = config.translucent&&_translucent;
    (*button).translucentStyle = config.translucentStyle;
}

- (UIImage *)rectangleImageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - UIScrollViewDelegate.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _containerView) {
        CGPoint contentOffset = scrollView.contentOffset;
        _effectView.transform = CGAffineTransformMakeTranslation(0, contentOffset.y);
        _titleLabel.transform = CGAffineTransformMakeTranslation(0, contentOffset.y);
    }
}
@end

@implementation AXVisualEffectButton
- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    _translucent = YES;
    _translucentStyle = AXAlertViewTranslucentLight;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && _translucent) {
        [self insertSubview:self.effectView atIndex:0];
    }
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [super insertSubview:view atIndex:index];
    if (_translucent) [super insertSubview:_effectView atIndex:0];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (_translucent) {
        [self sendSubviewToBack:_effectView];
    }
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    if (_translucent) {
        if (_translucentStyle == AXAlertViewTranslucentDark) {
            _effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else {
            _effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        [self insertSubview:self.effectView atIndex:0];
    } else {
        [_effectView removeFromSuperview];
    }
}

- (void)setTranslucentStyle:(AXAlertViewTranslucentStyle)translucentStyle {
    _translucentStyle = translucentStyle;
    
    [self setTranslucent:_translucent];
}

- (UIVisualEffectView *)effectView {
    if (_effectView) return _effectView;
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    _effectView.frame = self.bounds;
    _effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _effectView.userInteractionEnabled = NO;
    return _effectView;
}
@end

@implementation AXAlertViewAction
- (instancetype)initWithTitle:(NSString *)title handler:(AXAlertViewActionHandler)handler {
    return [self initWithTitle:title image:nil handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image handler:(AXAlertViewActionHandler)handler {
    if (self = [super init]) {
        _title = [title copy];
        _image = image;
        _handler = [handler copy];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [self.title isEqualToString:[object title]];
}

+ (instancetype)actionWithTitle:(NSString *)title handler:(AXAlertViewActionHandler)handler {
    return [self actionWithTitle:title image:nil handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image handler:(AXAlertViewActionHandler)handler {
    return [[self alloc] initWithTitle:title image:image handler:handler];
}
@end

@implementation AXAlertViewActionConfiguration
- (instancetype)init {
    if (self = [super init]) {
        _font = [UIFont boldSystemFontOfSize:15];
        _tintColor = [UIColor colorWithRed:0.996 green:0.725 blue:0.145 alpha:1.00];
        _backgroundColor = [UIColor whiteColor];
        _cornerRadius = 4;
        _preferedHeight = 44.0;
        _translucent = YES;
        _translucentStyle = AXAlertViewTranslucentLight;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    AXAlertViewActionConfiguration *config = [[AXAlertViewActionConfiguration allocWithZone:zone] init];
    config.font = [self.font copy];
    config.tintColor = [self.tintColor copy];
    config.backgroundColor = [self.backgroundColor copy];
    config.cornerRadius = self.cornerRadius;
    config.preferedHeight = self.preferedHeight;
    config.translucent = self.translucent;
    config.translucentStyle = self.translucentStyle;
    return config;
}
@end
