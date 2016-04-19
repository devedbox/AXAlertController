//
//  AXAlertView.m
//  AXAlertView
//
//  Created by ai on 16/4/5.
//  Copyright © 2016年 devedbox. All rights reserved.
//

#import "AXAlertView.h"
#import <pop/POP.h>

@interface AXAlertView ()
{
    NSMutableArray<AXAlertViewAction *> *_actionItems;
    NSArray<UIButton *> *_actionButtons;
    NSMutableDictionary<NSNumber*,AXAlertViewActionConfiguration*> *_actionConfig;
}
/// Title label.
@property(strong, nonatomic) UILabel *titleLabel;
/// Container view.
@property(strong, nonatomic) UIView *containerView;
/// Content container view.
@property(strong, nonatomic) UIView *contentContainerView;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
/// Blur effect view.
@property(strong, nonatomic) UIVisualEffectView *effectView;
#else
/// Blur effect bar.
@property(strong, nonatomic) UIToolbar *effectBar;
#endif
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
    _contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _customViewInset = UIEdgeInsetsMake(20, 0, 20, 0);
    _padding = 10;
    _horizontalLimits = 2;
    _dimBackground = YES;
    _preferedHeight = 354;
    _preferedMargin = 40;
    _cornerRadius = 6;
    _actionConfiguration = [[AXAlertViewActionConfiguration alloc] init];
    _actionConfiguration.backgroundColor = [UIColor colorWithRed:0.996 green:0.725 blue:0.145 alpha:1.00];
    _actionConfiguration.tintColor = [UIColor whiteColor];
    _actionConfiguration.font = [UIFont boldSystemFontOfSize:15];
    _actionConfiguration.cornerRadius = 4;
    _actionConfiguration.preferedHeight = 44.0;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.contentContainerView];
    [self.containerView addSubview:self.titleLabel];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tap];
    
    [self layoutSubviews];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
#pragma mark - Override
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self configureActions];
        [self configureCustomView];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect currentFrame = self.frame;
    // Frame of container view.
    CGRect rect_container = _containerView.frame;
    rect_container.origin.x = _preferedMargin;
    rect_container.origin.y = CGRectGetHeight(currentFrame)*.5-MIN(_preferedHeight, CGRectGetHeight(currentFrame)-_preferedMargin*2)*.5;
    rect_container.size = CGSizeMake(CGRectGetWidth(currentFrame)-_preferedMargin*2, MIN(_preferedHeight, CGRectGetHeight(currentFrame)-_preferedMargin*2));
    _containerView.frame = rect_container;
    
    // Frame of title label.
    CGRect rect_title = _titleLabel.frame;
    rect_title.origin.x = _contentInset.left;
    rect_title.origin.y = _contentInset.top;
    rect_title.size.width = CGRectGetWidth(rect_container)-(_contentInset.left+_contentInset.right);
    _titleLabel.frame = rect_title;
    
    // Frame of conent container view.
    CGRect rect_content = _contentContainerView.frame;
    rect_content.origin.x = _contentInset.left;
    rect_content.origin.y = CGRectGetMaxY(rect_title) + _padding;
    rect_content.size.width = CGRectGetWidth(rect_container)-(_contentInset.left+_contentInset.right);
    if (_actionButtons.count > _horizontalLimits) {
        rect_content.size.height = CGRectGetHeight(rect_container)-(_actionConfiguration.preferedHeight+_padding)*_actionButtons.count - _padding - (CGRectGetMinY(rect_content)-CGRectGetMinY(rect_container));
    } else {
        rect_content.size.height = CGRectGetHeight(rect_container)-_actionConfiguration.preferedHeight-_padding*2 - (CGRectGetMaxY(rect_title) + _padding);
    }
    _contentContainerView.frame = rect_content;
    
    [self configureActions];
    _customView.frame = _contentContainerView.bounds;
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
    [self viewWillShow:self animated:animated];
    [view addSubview:self];
    
    void (^_addPopPopUpAnimations)(UIView *_view) = ^(UIView *_view) {
        [_view.layer pop_removeAnimationForKey:@"kPOPLayerScaleXY"];
        [_view.layer pop_removeAnimationForKey:@"kPOPLayerOpacity"];
        [self.layer pop_removeAnimationForKey:@"kPOPLayerOpacity"];
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        anim.springBounciness = 10;
        anim.springSpeed = 20;
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        
        POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        
        opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        opacityAnim.duration = 0.3;
        opacityAnim.fromValue = @0.0;
        opacityAnim.toValue = @1.0;
        
//        [_view.layer pop_addAnimation:anim forKey:@"kPOPLayerScaleXY"];
        [_view.layer pop_addAnimation:opacityAnim forKey:@"kPOPLayerOpacity"];
        [self.layer pop_addAnimation:opacityAnim forKey:@"kPOPLayerOpacity"];
    };
    
    _containerView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.0, 0.0), CGAffineTransformMakeTranslation(0, -200));
    [UIView animateWithDuration:0.45 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:7 animations:^{
        _containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (finished) {
            [self viewDidShow:self animated:animated];
        }
    }];
    
    _addPopPopUpAnimations(_containerView);
}

- (void)showInView:(UIView *)view animated:(BOOL)animated completion:(AXAlertViewShowsBlock)didShow
{
    _didShow = [didShow copy];
    [self showInView:view animated:animated];
}

- (void)hide:(BOOL)animated {
    [self viewWillHide:self animated:animated];
    [UIView animateWithDuration:0.25 delay:0.25 options:7 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self viewDidHide:self animated:animated];
        }
    }];
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
}
#pragma mark - Getters
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = _titleColor;
    _titleLabel.font = _titleFont;
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return _titleLabel;
}

- (UIView *)containerView {
    if (_containerView) return _containerView;
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = _cornerRadius;
    _containerView.layer.masksToBounds = YES;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return _containerView;
}

- (UIView *)contentContainerView {
    if (_contentContainerView) return _contentContainerView;
    _contentContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentContainerView.backgroundColor = [UIColor orangeColor];
    _contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return _contentContainerView;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
- (UIVisualEffectView *)effectView {
    if (_effectView) return _effectView;
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _effectView.frame = self.bounds;
    _effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return _effectView;
}
#else
- (UIToolbar *)effectBar {
    if (_effectBar) return _effectBar;
    _effectBar = [[UIToolbar alloc] initWithFrame:self.bounds];
    for (UIView *view in [_effectBar subviews]) {
        if ([view isKindOfClass:[UIImageView class]] && [[view subviews] count] == 0) {
            [view setHidden:YES];
        }
    }
    _effectBar.barStyle = UIBarStyleBlack;
    _effectBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return _effectBar;
}
#endif

- (NSString *)title {
    return _titleLabel.text;
}

#pragma mark - Setters
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
    /*
    if (_translucent) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        [self insertSubview:self.effectView atIndex:0];
        _effectView.frame = _containerView.frame;
        _containerView.backgroundColor = [UIColor clearColor];
#else
        [self insertSubview:self.effectBar atIndex:0];
        effectBar.frame = _containerView.frame;
        _containerView.backgroundColor = [UIColor clearColor];
#endif
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        [_effectView removeFromSuperview];
        _containerView.backgroundColor = [UIColor whiteColor];
#else
        [_effectBar removeFromSuperview]
        _containerView.backgroundColor = [UIColor whiteColor];
#endif
    }
     */
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

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
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
    if (dimBackground) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
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
    AXAlertViewAction *action = _actionItems[sender.tag-1];
    if (action.handler) {
        action.handler(action);
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    if (_touch != NULL && _touch != nil) {
        _touch(self);
    }
    CGPoint point = [tap locationInView:self];
    if (CGRectContainsRect(self.containerView.frame, CGRectMake(point.x, point.y, 1, 1))) {
        return;
    }
    [self hide:YES];
}
#pragma mark - Public
- (void)viewWillShow:(AXAlertView *)alertView animated:(BOOL)animated {
    if (_willShow != NULL && _willShow != nil) {
        _willShow(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillShow:)]) {
        [_delegate alertViewWillShow:self];
    }
}

- (void)viewDidShow:(AXAlertView *)alertView animated:(BOOL)animated {
    if (_didShow != NULL && _didShow != nil) {
        _didShow(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidShow:)]) {
        [_delegate alertViewDidShow:self];
    }
}

- (void)viewWillHide:(AXAlertView *)alertView animated:(BOOL)animated {
    if (_willHide != NULL && _willHide != nil) {
        _willHide(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillHide:)]) {
        [_delegate alertViewWillHide:self];
    }
}

- (void)viewDidHide:(AXAlertView *)alertView animated:(BOOL)animated {
    if (_didHide != NULL && _didHide != nil) {
        _didHide(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidHide:)]) {
        [_delegate alertViewDidHide:self];
    }
}

#pragma mark - Private

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
        for (NSInteger i = _actionButtons.count-1; i >=0 ; i--) {
            UIButton *button = _actionButtons[_actionButtons.count-1-i];
            button.tag = _actionButtons.count-1-i;
            [button addTarget:self action:@selector(handleActionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(_contentInset.left, CGRectGetHeight(_containerView.frame) - (CGRectGetHeight(_containerView.frame)- MIN(_preferedHeight, CGRectGetHeight(_containerView.frame)))*.5 - (_actionConfiguration.preferedHeight+_padding)*(i+1), CGRectGetWidth(_containerView.frame)-(_contentInset.left+_contentInset.right), _actionConfiguration.preferedHeight)];
            [self.containerView addSubview:button];
        }
    } else {
        CGFloat buttonWidth = (CGRectGetWidth(_containerView.frame)-_contentInset.left-_contentInset.right-_padding*(_actionButtons.count-1))/_actionButtons.count;
        for (NSInteger i = 0; i < _actionButtons.count; i++) {
            UIButton *button = _actionButtons[i];
            button.tag = i+1;
            [button addTarget:self action:@selector(handleActionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(_contentInset.left+(buttonWidth+_padding)*i, CGRectGetHeight(_containerView.frame) - (CGRectGetHeight(_containerView.frame)- MIN(_preferedHeight, CGRectGetHeight(_containerView.frame)))*.5 - (_actionConfiguration.preferedHeight+_padding), buttonWidth, _actionConfiguration.preferedHeight)];
            [self.containerView addSubview:button];
        }
    }
}

- (NSArray<UIButton*> *_Nonnull)buttonsWithActions:(NSArray<AXAlertViewAction*> *_Nonnull)actions {
    NSMutableArray *buttons = [@[] mutableCopy];
    for (NSInteger i = 0; i < actions.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:[actions[i] title] forState:UIControlStateNormal];
        AXAlertViewActionConfiguration *config = [_actionConfig objectForKey:@(i)];
        if (!config) {
            config = _actionConfiguration;
        }
        [button setBackgroundColor:config.backgroundColor?config.backgroundColor:_actionConfiguration.backgroundColor];
        [button.titleLabel setFont:config.font?config.font:_actionConfiguration.font];
        [button setTintColor:config.tintColor?config.tintColor:_actionConfiguration.tintColor];
        button.layer.cornerRadius = config.cornerRadius>0?config.cornerRadius:_actionConfiguration.cornerRadius;
        button.layer.masksToBounds = YES;
        [buttons addObject:button];
    }
    return buttons;
}
@end

@implementation AXAlertViewAction
- (instancetype)initWithTitle:(NSString *)title handler:(AXAlertViewActionHandler)handler {
    if (self = [super init]) {
        _title = title;
        _handler = [handler copy];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [self.title isEqualToString:[object title]];
}

+ (instancetype)actionWithTitle:(NSString *)title handler:(AXAlertViewActionHandler)handler {
    return [[self alloc] initWithTitle:title handler:handler];
}
@end

@implementation AXAlertViewActionConfiguration

@end