//
//  AXAlertView.m
//  AXAlertView
//
//  Created by ai on 16/4/5.
//  Copyright © 2016年 devedbox. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "AXAlertView.h"

// #ifndef AXAlertViewUsingAutolayout
// #define AXAlertViewUsingAutolayout (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0)
// #define AXAlertViewUsingAutolayout 0
// #endif
#ifndef AXAlertViewCustomViewHooks2
#define AXAlertViewCustomViewHooks2(_CustomView, CocoaView) @interface _CustomView : CocoaView @end @implementation _CustomView @end
#endif
#ifndef AXAlertViewCustomViewHooks
#define AXAlertViewCustomViewHooks(_CustomView) AXAlertViewCustomViewHooks2(_CustomView, UIView)
#endif
#ifndef AXObserverRemovingViewHooks
#define AXObserverRemovingViewHooks(_CustomView, CocoaView, KeyPaths) @interface _CustomView : UIScrollView { @public id __weak _observer; } @end\
@implementation _CustomView - (void)dealloc { for (NSString *keyPath in KeyPaths) { if (_observer != nil) [self removeObserver:_observer forKeyPath:keyPath]; } } @end
#endif
#ifndef AXAlertPlaceholderViewHooks
#define AXAlertPlaceholderViewHooks(_PlaceholderView) @interface _PlaceholderView : UIImageView @property(copy, nonatomic) NSString *identifier; @end @implementation _PlaceholderView @end
#endif

AXAlertViewCustomViewHooks(_AXAlertContentHeaderView)
AXAlertViewCustomViewHooks(_AXAlertContentFooterView)
AXAlertViewCustomViewHooks2(_AXAlertContentSeparatorView, UIImageView)
AXAlertViewCustomViewHooks2(_AXAlertContentFlexibleView, UIImageView)
AXObserverRemovingViewHooks(_AXAlertViewScrollView, UIScrollView, @[@"contentSize"])
AXAlertPlaceholderViewHooks(_AXAlertContentPlacehodlerView)

@interface AXAlertView () <UIScrollViewDelegate>
{
    @private
    NSArray<__kindof UIButton *> *_actionButtons;
    
    // Transition view of translucent.
    UIView *__weak _translucentTransitionView;
    // Single seprator view.
    _AXAlertContentSeparatorView *__weak _singleSeparator;
    
    UIColor * _backgroundColor;
    // Contraints.
    NSLayoutConstraint *__weak _leadingOfContainer; // Leading contraint of the container view to self.
    NSLayoutConstraint *__weak _trailingOfContainer; // Trailing contraint of the container view to self.
    NSLayoutConstraint *__weak _heightOfContainer; // Height contraint of the container view to self.
    NSLayoutConstraint *__weak _topOfContainer; // Top contraint of the container view to self.
    NSLayoutConstraint *__weak _bottomOfContainer;// Bottom contraint of the container view to self.
    
    NSLayoutConstraint *__weak _leadingOfTitleLabel;// Leading contraint of the title label to container view.
    NSLayoutConstraint *__weak _trailingOfTitleLabel;// Trailing contraint of the title label to container view.
    NSLayoutConstraint *__weak _topOfTitleLabel;// Top contraint of the title label to container view.
    NSLayoutConstraint *__weak _bottomOfTitleAndTopOfContent;// Bottom contraint of title label and top contraint of content view to the container view.
    NSLayoutConstraint *__weak _leadingOfContent;// Leading contraint of the content view to the container view.
    NSLayoutConstraint *__weak _trailingOfContent;// Trailing contraint of the content view to the container view.
    NSLayoutConstraint *__weak _bottomOfContent;// Bottom contraint of the content view to the container view.
    
    NSLayoutConstraint *__weak _leadingOfCustom;// Leading contraint of custom view to the content view.
    NSLayoutConstraint *__weak _trailingOfCustom;// Trailing contraint of custom view to the content view.
    NSLayoutConstraint *__weak _topOfCustom;// Top contraint of custom view to the content view.
    NSLayoutConstraint *__weak _bottomOfCustomAndTopOfStack;// Bottom contraint of custom view and top contraint of stack view to the content view.
    NSLayoutConstraint *__weak _topOfStackView;// Top contraint of stack view to the content view.
    NSLayoutConstraint *__weak _leadingOfStackView;// Leading contraint of stack view to the content view.
    NSLayoutConstraint *__weak _trailingOfStackView;// Trailing contraint of stack view to the content view.
    NSLayoutConstraint *__weak _bottomOfStackView;// Bottom contraint of stack view to the content view.
    NSLayoutConstraint *__weak _widthOfStackView;// Width contraint of stack view to the container view.
    
    NSLayoutConstraint *__weak _heightOfContentView;// Height contraint of the content view.
    
    NSLayoutConstraint *__weak _equalHeightOfEffectFlexibleAndStack; // Equal height contraint of effect flexible view and stack view.
    NSLayoutConstraint *__weak _heightOfEffectFlexibleView;// Height contraint of the flexible view to the effect view.
    
    CAShapeLayer *_effectMaskLayer;
    CALayer *_effectOpacityLayer;
    
    /// Content header view.
    _AXAlertContentHeaderView *_contentHeaderView;
    _AXAlertContentFooterView *_contentFooterView;
}
/// Title label.
@property(strong, nonatomic) UILabel *titleLabel;
/// Container view.
@property(strong, nonatomic) UIView *containerView;
/// Content container view.
@property(strong, nonatomic) _AXAlertViewScrollView *contentContainerView;
/// Effect flexilbe view.
@property(strong, nonatomic) _AXAlertContentFlexibleView *effectFlexibleView;
/// Blur effect view.
@property(strong, nonatomic) UIVisualEffectView *effectView;
/// Effect flexible view.
@property(strong, nonatomic) _AXAlertContentFlexibleView *stackFlexibleView;
/// Stack view.
@property(strong, nonatomic) UIStackView *stackView;

@property(assign, nonatomic) BOOL _shouldExceptContentBackground;
@property(readonly, nonatomic) BOOL _showedOnView;
@end

@interface _AXTranslucentButton : UIButton {
    CAShapeLayer *_maskLayer;
    CALayer *_opacityLayer;
    // Single seprator view.
    _AXAlertContentSeparatorView *__weak _singleSeparator;
    
    id _arg1;
    id _arg2;
@public
    uint8_t _type;
    AXAlertViewAction *__weak _action;
}
/// Translucent. Defailts to YES.
@property(assign, nonatomic) BOOL translucent;
/// Translucent style. Defaults to Light.
@property(assign, nonatomic) AXAlertViewTranslucentStyle translucentStyle;
/// Mask view.
@property(strong, nonatomic) UIImageView *masksView;
// Direction:
// - 0: Lop.
// - 1: Left.
// - 2: Bottom.
// - 3: Right.
- (void)_setExceptionAllowedWidth:(CGFloat)arg1 direction:(int8_t)arg2;
- (void)_setExceptionSeparatorLayerWidth:(CGFloat)arg1 direction:(int8_t)arg2;
@end

static CGFloat UIEdgeInsetsGetHeight(UIEdgeInsets insets) { return insets.top + insets.bottom; }
static CGFloat UIEdgeInsetsGetWidth(UIEdgeInsets insets) { return insets.left + insets.right; }

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
    _titleInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _customViewInset = UIEdgeInsetsMake(0, 10, 10, 10);
    _padding = 10;
    _actionItemPadding = .0;
    _actionItemMargin = .0;
    _horizontalLimits = 2;
    _opacity = 0.4;
    _preferedHeight = .0;
    _preferedMargin = UIEdgeInsetsMake(40, 40, 40, 40);
    _cornerRadius = 6;
    _actionConfiguration = [[AXAlertViewActionConfiguration alloc] init];
    _actionConfiguration.backgroundColor = [UIColor colorWithRed:0.996 green:0.725 blue:0.145 alpha:1.00];
    _actionConfiguration.tintColor = [UIColor whiteColor];
    _actionConfiguration.font = [UIFont boldSystemFontOfSize:15];
    _actionConfiguration.cornerRadius = 4;
    _actionConfiguration.preferedHeight = 44.0;
    _actionConfiguration.translucent = YES;
    
    _showsSeparators = YES;
    
    __shouldExceptContentBackground = YES;
    
    super.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.contentContainerView];
    [self.containerView addSubview:self.titleLabel];
    
    if ([[self class] usingAutolayout]) {
        [self.contentContainerView addSubview:self.stackView];
        
        // Add contraints to self of container view.
        [self _addContraintsOfContainerToSelf];
        // Add contraints to self of the views.
        [self _addContraintsOfTitleLabelAndContentViewToContainerView];
        // Add contraints to custom and stack view.
        [self _addContraintsOfCustomViewAndStackViewToContentView];
    }
    
    [_contentContainerView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [_contentContainerView removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark - Override
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        CGFloat height;
        CGFloat flag;
        [self _getHeightOfContentView:&height flag:&flag withContentSize:contentSize];
        
        _contentContainerView.scrollEnabled = height>=flag?YES:NO;
        if (_translucent) {
            if (height>=flag ) {
                [self _setupContentHookedView];
                [self _updateFramesOfHookedVeiwsWithContentOffset:_contentContainerView.contentOffset ofScrollView:_contentContainerView];
            } else {
                [_contentHeaderView removeFromSuperview];
                [_contentFooterView removeFromSuperview];
            }
        }
        
        if ([[self class] usingAutolayout]) {
            if (_translucent) {
                if (height >= flag) {
                    _equalHeightOfEffectFlexibleAndStack.active = NO;
                    _heightOfEffectFlexibleView.active = !_equalHeightOfEffectFlexibleAndStack.active;
                    
                    NSLayoutConstraint *heightOfStack =
                    [NSLayoutConstraint constraintWithItem:self.stackFlexibleView
                                                 attribute:NSLayoutAttributeHeight
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                multiplier:1.0 constant:0.0];
                    [_stackFlexibleView removeConstraints:_stackFlexibleView.constraints];
                    [_stackFlexibleView addConstraint:heightOfStack];
                    _heightOfEffectFlexibleView = heightOfStack;
                } else {
                    _equalHeightOfEffectFlexibleAndStack.active = YES;
                    _heightOfEffectFlexibleView.active = !_equalHeightOfEffectFlexibleAndStack.active;
                    
                    NSLayoutConstraint *equalOfStack =
                    [NSLayoutConstraint constraintWithItem:self.stackFlexibleView
                                                 attribute:NSLayoutAttributeHeight
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_stackView
                                                 attribute:NSLayoutAttributeHeight
                                                multiplier:1.0 constant:0.0];
                    [_stackFlexibleView removeConstraints:_stackFlexibleView.constraints];
                    if (_equalHeightOfEffectFlexibleAndStack) [_containerView removeConstraint:_equalHeightOfEffectFlexibleAndStack];
                    [_containerView addConstraint:equalOfStack];
                    _equalHeightOfEffectFlexibleAndStack = equalOfStack;
                }
            }
            
            [self _updateHeightConstraintsOfContentViewWithHeight:height];
        }
        
        [self setNeedsDisplay];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (_processing) return self;
    return [super hitTest:point withEvent:event];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        // [self configureActions];
        [self configureCustomView];
        
        [self setTranslucent:_translucent];
    } else {
        // Ensure remove the translucent transition view from super view.
        [_translucentTransitionView removeFromSuperview];
    }
}

- (void)layoutSubviews {
    // Call SUPER.
    [super layoutSubviews];
    
    if (![[self class] usingAutolayout]) {
        // Get the current frame of SELF.
        CGRect currentFrame = self.frame;
        // Initialize a CGSize struct of custom view and title label using the current frame and prefered magin and the insets.
        CGSize sizeOfCustomView = CGSizeMake(CGRectGetWidth(currentFrame)-UIEdgeInsetsGetWidth(_preferedMargin) - (_contentInset.left+_contentInset.right)-(_customViewInset.left+_customViewInset.right), 0);
        CGSize sizeOfTitleLabel = CGSizeMake(CGRectGetWidth(currentFrame)-UIEdgeInsetsGetWidth(_preferedMargin) - (_contentInset.left+_contentInset.right)-(_titleInset.left+_titleInset.right), 0);
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
                AXAlertViewAction *action = _actionItems[i];
                NSString *identifier = action.identifier;
                AXAlertViewActionConfiguration *config = _actionConfig[identifier.length?identifier:[NSString stringWithFormat:@"%@", @(i)]]?:_actionConfiguration;
                if (config) {
                    if (i == 0) {
                        heightOfContainer += _padding;
                    } else {
                        heightOfContainer += _actionItemPadding;
                    }
                    heightOfContainer += /*0.5+ */config.preferedHeight;
                    heightOfItems += /*0.5+ */config.preferedHeight;
                }
            }
        } else {
            CGFloat maxHeightOfItem = .0;
            for (int i = 0; i < _actionItems.count; i++) {
                AXAlertViewAction *action = _actionItems[i];
                NSString *identifier = action.identifier;
                AXAlertViewActionConfiguration *config = _actionConfig[identifier.length?identifier:[NSString stringWithFormat:@"%@", @(i)]]?:_actionConfiguration;
                if (config) {
                    maxHeightOfItem = MAX(maxHeightOfItem, config.preferedHeight);
                    heightOfItems = maxHeightOfItem;
                }
            }
            heightOfContainer += _padding;
            heightOfContainer += /*0.5+ */heightOfItems;
        }
        heightOfContainer += _contentInset.bottom;
        
        heightOfContainer = MAX(heightOfContainer, _preferedHeight);
        
        // Frame of container view.
        CGRect rect_container = _containerView.frame;
        rect_container.origin.x = _preferedMargin.left;
        
        if (heightOfContainer > CGRectGetHeight(currentFrame)-UIEdgeInsetsGetHeight(_preferedMargin)) { // Too large to show.
            rect_container.origin.y = _preferedMargin.top;
            rect_container.size = CGSizeMake(CGRectGetWidth(currentFrame)-UIEdgeInsetsGetWidth(_preferedMargin), CGRectGetHeight(currentFrame)-UIEdgeInsetsGetHeight(_preferedMargin));
            _containerView.frame = rect_container;
            // Enabled the scroll of the content container view.
            _contentContainerView.scrollEnabled = YES;
            // Set up hooked content view.
            [self _setupContentHookedView];
            
            _effectView.frame = CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), heightOfContainer);
        } else {
            rect_container.origin.y = CGRectGetHeight(currentFrame)*.5-MIN(heightOfContainer, CGRectGetHeight(currentFrame)-UIEdgeInsetsGetHeight(_preferedMargin))*.5;
            rect_container.size = CGSizeMake(CGRectGetWidth(currentFrame)-UIEdgeInsetsGetWidth(_preferedMargin), MIN(heightOfContainer, CGRectGetHeight(currentFrame)-UIEdgeInsetsGetHeight(_preferedMargin)));
            _containerView.frame = rect_container;
            // Disable the scroll of the content container view.
            _contentContainerView.scrollEnabled = NO;
            // Using the bounds of the container view for the short content:
            //
            // _effectView.frame = CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), _contentInset.top+_titleInset.top+sizeOfTitleLabel.height+sizeOfCustomView.height+_titleInset.bottom);
            _effectView.frame = _containerView.bounds;
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
        rect_content.origin.y = CGRectGetMaxY(rect_title) + _titleInset.bottom + _padding + _customViewInset.top;
        rect_content.size.width = CGRectGetWidth(rect_container)-(_contentInset.left+_contentInset.right);
        rect_content.size.height = CGRectGetHeight(rect_container)-sizeOfTitleLabel.height-_contentInset.top-_titleInset.top-_titleInset.bottom-_padding-_customViewInset.top-_contentInset.bottom;
        _contentContainerView.frame = rect_content;
        // Calculate the content size of the content container view.
        _contentContainerView.contentSize = CGSizeMake(CGRectGetWidth(rect_container)-(_contentInset.left+_contentInset.right), heightOfContainer-sizeOfTitleLabel.height-_contentInset.top-_titleInset.top-_titleInset.bottom-_padding-_customViewInset.top-_contentInset.bottom);
        _customView.frame = CGRectMake(_customViewInset.left, /*_customViewInset.top*/0, sizeOfCustomView.width, sizeOfCustomView.height-(_customViewInset.top+_customViewInset.bottom));
    }
    
    [self configureActions];
    [self setNeedsDisplay];
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
    // Delays to configure action items at layouting subviews.
    [self _layoutSubviews];
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
    // Delays to configure action items at layouting subviews.
    [self _layoutSubviews];
}

- (void)show:(BOOL)animated {
    if (_processing) return;
    [self viewWillShow:self animated:animated];
    _containerView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    __weak typeof(self) wself = self;
    if (animated) [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:(0 << 16)|(3 << 24) animations:^{
        _containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (finished) {
            [wself viewDidShow:wself animated:animated];
        }
    }]; else {
        [self viewDidShow:self animated:NO];
    }
    /*
     objc_setAssociatedObject(self.containerView.chainAnimator, @selector(_showComplete:), @(animated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
     
     if (animated) {
     [CATransaction begin];
     [self.containerView.chainAnimator.basic.property(@"transform.scale").duration(0.01).toValue(@1.2).nextToSpring.property(@"transform.scale").duration(0.5).fromValue(@1.2).toValue(@1.0).mass(0.5).stiffness(100).damping(20) easeOut].target(self).complete(@selector(_showComplete:)).animate();
     [CATransaction flush];
     [CATransaction commit];
     } else {
     [self _showComplete:self.chainAnimator];
     }
     */
}

- (void)show:(BOOL)animated completion:(AXAlertViewShowsBlock)didShow
{
    _didShow = [didShow copy];
    [self show:animated];
}

- (void)hide:(BOOL)animated {
    if (_processing) return;
    [self viewWillHide:self animated:animated];
    __weak typeof(self) wself = self;
    if (animated) [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [wself viewDidHide:wself animated:animated];
        }
    }]; else {
        [self viewDidHide:self animated:NO];
    }
    /*
    objc_setAssociatedObject(self.containerView.chainAnimator, @selector(_hideComplete:), @(animated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.chainAnimator.basic.property(@"opacity").fromValue(@(1.0)).toValue(@(.0)).duration(animated?0.25:.0).target(self).complete(@selector(_hideComplete:)).animate();
     */
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
    
    CGPathRelease(outterPath);
    if (!__shouldExceptContentBackground) return;
    
    CGRect rectOfContainerView = self.containerView.frame;
    if (CGRectGetWidth(rectOfContainerView) < _cornerRadius*2 || CGRectGetHeight(rectOfContainerView) < _cornerRadius*2) return;
    CGPathRef innerPath = CGPathCreateWithRoundedRect(rectOfContainerView, _cornerRadius, _cornerRadius, nil);
    CGContextAddPath(context, innerPath);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextFillPath(context);
    
    CGPathRelease(innerPath);
}
#pragma mark - Getters
- (UIView *)contentView { return _containerView; }

- (NSArray<AXAlertViewAction *> *)actionItems { return [_actionItems copy]; }

- (BOOL)_showedOnView {
    return (!_processing && self.superview!=nil);
}

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
    if ([[self class] usingAutolayout]) {
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    } else {
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _titleLabel;
}

- (UIView *)containerView {
    if (_containerView) return _containerView;
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _containerView.clipsToBounds = YES;
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = _cornerRadius;
    _containerView.layer.masksToBounds = YES;
    if ([[self class] usingAutolayout]) {
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    } else {
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _containerView;
}

- (_AXAlertViewScrollView *)contentContainerView {
    if (_contentContainerView) return _contentContainerView;
    _contentContainerView = [[_AXAlertViewScrollView alloc] initWithFrame:CGRectZero];
    _contentContainerView->_observer = self;
    _contentContainerView.backgroundColor = [UIColor clearColor];
    _contentContainerView.showsVerticalScrollIndicator = NO;
    _contentContainerView.showsHorizontalScrollIndicator = NO;
    _contentContainerView.alwaysBounceVertical = YES;
    _contentContainerView.delegate = self;
    if ([[self class] usingAutolayout]) {
        _contentContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    } else {
        _contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _contentContainerView;
}

- (_AXAlertContentFlexibleView *)effectFlexibleView {
    if (_effectFlexibleView) return _effectFlexibleView;
    _effectFlexibleView = [_AXAlertContentFlexibleView new];
    _effectFlexibleView.backgroundColor = [UIColor clearColor];
    _effectFlexibleView.translatesAutoresizingMaskIntoConstraints = NO;
    return _effectFlexibleView;
}

- (UIVisualEffectView *)effectView {
    if (_effectView) return _effectView;
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    _effectView.frame = self.bounds;
    if ([[self class] usingAutolayout]) {
        _effectView.translatesAutoresizingMaskIntoConstraints = NO;
    } else {
        _effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _effectView;
}

- (_AXAlertContentFlexibleView *)stackFlexibleView {
    if (_stackFlexibleView) return _stackFlexibleView;
    _stackFlexibleView = [_AXAlertContentFlexibleView new];
    _stackFlexibleView.backgroundColor = [UIColor clearColor];
    _stackFlexibleView.translatesAutoresizingMaskIntoConstraints = NO;
    return _stackFlexibleView;
}

- (UIStackView *)stackView {
    if (_stackView) return _stackView;
    _stackView = [UIStackView new];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    return _stackView;
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
    if (![[self class] usingAutolayout]) {
        [_titleLabel sizeToFit];
        [self _layoutSubviews];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    _containerView.layer.cornerRadius = _cornerRadius;
    _containerView.layer.masksToBounds = _cornerRadius!=0?YES:NO;
}

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *)configuration forKey:(NSString *)key {
    if (!_actionConfig) {
        _actionConfig = [@{} mutableCopy];
    }
    [_actionConfig setObject:configuration forKey:key];
    // Update the configuration of the button at index.
    [self _updateConfigurationOfItemForKey:key];
}

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *)configuration forItemAtIndex:(NSUInteger)index {
    [self setActionConfiguration:configuration forKey:[NSString stringWithFormat:@"%@", @(index)]];
}

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *)configuration forAction:(AXAlertViewAction *)action {
    if (action.identifier.length) {
        [self setActionConfiguration:configuration forKey:action.identifier];
    }
}

- (void)setCustomView:(UIView *)customView {
    if (customView == nil) {
        [_customView removeFromSuperview];
        _customView = nil;
        
        if ([[self class] usingAutolayout]) {
            [_stackView removeFromSuperview];
            
            [self _addContraintsOfCustomViewAndStackViewToContentView];
        }
    } else {
        _customView = customView;
        [self configureCustomView];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel.textColor = _titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    _titleLabel.font = _titleFont;
    [self _layoutSubviews];
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    if (_translucent) {
        if ([[self class] usingAutolayout]) {
            [self.containerView insertSubview:self.effectFlexibleView atIndex:0];
            [self.containerView insertSubview:self.stackFlexibleView atIndex:0];
        }
        
        [self.containerView insertSubview:self.effectView atIndex:0];
        if (_translucentStyle == AXAlertViewTranslucentDark) {
            _effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else {
            _effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        
        if ([[self class] usingAutolayout]) {
            [self _addContraintsOfEffectViewToContainerView];
        } else {
            _effectView.frame = _containerView.bounds;
            // Set up hooked view if needed.
            if (_contentContainerView.scrollEnabled) [self _setupContentHookedView];
        }

        [self _layoutSubviews];
        
        _containerView.backgroundColor = [UIColor clearColor];
    } else {
        [_effectFlexibleView removeFromSuperview];
        [_effectView removeFromSuperview];
        [_stackFlexibleView removeFromSuperview];
        _containerView.backgroundColor = _backgroundColor?:[UIColor whiteColor];
    }
}

- (void)setShowsSeparators:(BOOL)showsSeparators {
    _showsSeparators = showsSeparators;
    [self _layoutSubviews];
}

- (void)setTranslucentStyle:(AXAlertViewTranslucentStyle)translucentStyle {
    _translucentStyle = translucentStyle;
    
    [self setTranslucent:_translucent];
    // Set up hooked view if needed.
    if (_contentContainerView.scrollEnabled) [self _setupContentHookedView];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    
    if ([[self class] usingAutolayout]) {
        _leadingOfTitleLabel.constant = -_contentInset.left-_titleInset.left;
        _trailingOfTitleLabel.constant = _contentInset.right+_titleInset.right;
        _topOfTitleLabel.constant = -_contentInset.top-_titleInset.top;
        _leadingOfContent.constant = -_contentInset.left;
        _trailingOfContent.constant = _contentInset.right;
        _bottomOfContent.constant = _contentInset.bottom;
        _widthOfStackView.constant = _contentInset.left+_contentInset.right+_actionItemMargin*2;
    }
    
    [self configureCustomView];
    [self _layoutSubviews];
}

- (void)setCustomViewInset:(UIEdgeInsets)customViewInset {
    _customViewInset = customViewInset;

    if ([[self class] usingAutolayout]) {
        _leadingOfCustom.constant = -_customViewInset.left;
        _trailingOfCustom.constant = _customViewInset.right;
        _bottomOfTitleAndTopOfContent.constant = -_titleInset.bottom-_padding-_customViewInset.top;
        _bottomOfCustomAndTopOfStack.constant = -_customViewInset.bottom-_padding;
    }
    
    [self configureCustomView];
    [self _layoutSubviews];
}

- (void)setTitleInset:(UIEdgeInsets)titleInset {
    _titleInset = titleInset;

    if ([[self class] usingAutolayout]) {
        _leadingOfTitleLabel.constant = -_contentInset.left-_titleInset.left;
        _trailingOfTitleLabel.constant = _contentInset.right+_titleInset.right;
        _topOfTitleLabel.constant = -_contentInset.top-_titleInset.top;
        _bottomOfTitleAndTopOfContent.constant = -_titleInset.bottom-_padding-_customViewInset.top;
    }
    
    [self _layoutSubviews];
}

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    
    if ([[self class] usingAutolayout]) {
        _bottomOfTitleAndTopOfContent.constant = -_titleInset.bottom-_padding-_customViewInset.top;
        _bottomOfCustomAndTopOfStack.constant = -_customViewInset.bottom-_padding;
        _topOfStackView.constant = -_padding-_customViewInset.top;
    }
    
    [self configureCustomView];
    [self _layoutSubviews];
}

- (void)setActionItemMargin:(CGFloat)actionItemMargin {
    _actionItemMargin = actionItemMargin;

    if ([[self class] usingAutolayout]) {
        _leadingOfStackView.constant = -_actionItemMargin;
        _trailingOfStackView.constant = _actionItemMargin;
        _widthOfStackView.constant = _contentInset.left+_contentInset.right+_actionItemMargin*2;
    }
    
    [self configureCustomView];
    [self _layoutSubviews];
}

- (void)setActionItemPadding:(CGFloat)actionItemPadding {
    _actionItemPadding = actionItemPadding;
    [self _layoutSubviews];
    [self configureCustomView];
}

- (void)setHorizontalLimits:(NSInteger)horizontalLimits {
    _horizontalLimits = horizontalLimits;
    // Delays to configure action items at layouting subviews.
    [self _layoutSubviews];
}

- (void)setOpacity:(CGFloat)opacity {
    _opacity = opacity;
    [self setNeedsDisplay];
}

- (void)setPreferedHeight:(CGFloat)preferedHeight {
    _preferedHeight = preferedHeight;

    if ([[self class] usingAutolayout]) {
        _heightOfContainer.constant = _preferedHeight;
    }
    
    [self _layoutSubviews];
    [self configureCustomView];
}

- (void)setPreferedMargin:(AXEdgeMargins)preferedMargin {
    _preferedMargin = preferedMargin;
    
    if ([[self class] usingAutolayout]) {
        _leadingOfContainer.constant = -_preferedMargin.left;
        _trailingOfContainer.constant = _preferedMargin.right;
        _topOfContainer.constant = -_preferedMargin.top;
        _bottomOfContainer.constant = _preferedMargin.bottom;
    }
    
    [self _layoutSubviews];
    [self configureCustomView];
}

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *)actionConfiguration {
    _actionConfiguration = actionConfiguration;
    [self _layoutSubviews];
}

- (void)set_shouldExceptContentBackground:(BOOL)_shouldExceptContentBackground {
    __shouldExceptContentBackground = _shouldExceptContentBackground;
    [self setNeedsDisplay];
}

#pragma mark - Actions
- (void)handleDeviceOrientationDidChangeNotification:(NSNotification *)aNote {
    [self performSelector:@selector(_handleDeviceOrientationDidChange) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
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
    
    [self _layoutSubviews];
    /*
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
    */
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
    
    _processing = YES;
    
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
- (void)_layoutSubviews {
    if (![self _showedOnView]) return;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)_handleDeviceOrientationDidChange {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:_cmd object:nil];
    [self _layoutSubviews];

    if (![[self class] usingAutolayout]) {
        [self _updateFramesOfHookedVeiwsWithContentOffset:_contentContainerView.contentOffset ofScrollView:_contentContainerView];
    }
    
    [self set_shouldExceptContentBackground:NO];
    [self performSelector:@selector(_enabled_shouldExceptContentBackground) withObject:nil afterDelay:0.25];
}

- (void)_enabled_shouldExceptContentBackground {
    [self set_shouldExceptContentBackground:YES];
}

- (void)_addContraintsOfContainerToSelf {
    NSLayoutConstraint *leadingOfContainer =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:-_preferedMargin.left];
    NSLayoutConstraint *trailingOfContainer =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:_preferedMargin.right];
    NSLayoutConstraint *heightOfContainer =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:_preferedHeight];
    heightOfContainer.priority = UILayoutPriorityDefaultLow;
    heightOfContainer.active = NO;
    NSLayoutConstraint *centerYOfContainer =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0];
    NSLayoutConstraint *topOfContainer =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-_preferedMargin.top];
    NSLayoutConstraint *bottomOfContainer =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:_preferedMargin.bottom];
    [self addConstraints:@[leadingOfContainer, trailingOfContainer/*, heightOfContainer*/, centerYOfContainer, /* topOfContainer, bottomOfContainer*/]];
    
    [_containerView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    // Add references to the contraints.
    _leadingOfContainer = leadingOfContainer;
    _trailingOfContainer = trailingOfContainer;
    _heightOfContainer = heightOfContainer;
    _topOfContainer = topOfContainer;
    _bottomOfContainer = bottomOfContainer;
}

- (void)_addContraintsOfTitleLabelAndContentViewToContainerView {
    NSLayoutConstraint *leadingOfTitleLabel =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_titleLabel
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:-_contentInset.left-_titleInset.left];
    NSLayoutConstraint *trailingOfTitleLabel =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_titleLabel
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:_contentInset.right+_titleInset.right];
    NSLayoutConstraint *topOfTitleLabel =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_titleLabel
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-_contentInset.top-_titleInset.top];
    
    NSLayoutConstraint *bottomOfTitleLabelAndTopOfContentView =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_contentContainerView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-_titleInset.bottom-_padding-_customViewInset.top];
    NSLayoutConstraint *leadingOfContentView =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_contentContainerView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:-_contentInset.left];
    NSLayoutConstraint *trailingOfContentView =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_contentContainerView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:_contentInset.right];
    NSLayoutConstraint *bottomOfContentView =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_contentContainerView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:_contentInset.bottom];
    
    [_containerView addConstraints:@[leadingOfTitleLabel, trailingOfTitleLabel, topOfTitleLabel, bottomOfTitleLabelAndTopOfContentView, leadingOfContentView, trailingOfContentView, bottomOfContentView]];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    // Add references to the contraints.
    _leadingOfTitleLabel = leadingOfTitleLabel;
    _trailingOfTitleLabel = trailingOfTitleLabel;
    _topOfTitleLabel = topOfTitleLabel;
    _bottomOfTitleAndTopOfContent = bottomOfTitleLabelAndTopOfContentView;
    _leadingOfContent = leadingOfContentView;
    _trailingOfContent = trailingOfContentView;
    _bottomOfContent = bottomOfContentView;
}

- (void)_addContraintsOfCustomViewAndStackViewToContentView {
    NSLayoutConstraint *bottomOfCustomAndTopOfStackView;
    
    if (_customView) {
        NSLayoutConstraint *leadingOfCustomView =
        [NSLayoutConstraint constraintWithItem:_contentContainerView
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_customView
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1.0
                                      constant:-_customViewInset.left];
        NSLayoutConstraint *trailingOfCustomView =
        [NSLayoutConstraint constraintWithItem:_contentContainerView
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_customView
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                      constant:_customViewInset.right];
        NSLayoutConstraint *topOfCustomView =
        [NSLayoutConstraint constraintWithItem:_contentContainerView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_customView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0];
        bottomOfCustomAndTopOfStackView =
        [NSLayoutConstraint constraintWithItem:_customView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_stackView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:-_customViewInset.bottom-_padding];
        
        // Add contraints to content view.
        [_contentContainerView addConstraints:@[leadingOfCustomView, trailingOfCustomView, topOfCustomView, bottomOfCustomAndTopOfStackView]];
        
        // Add references to the contraints.
        _leadingOfCustom = leadingOfCustomView;
        _trailingOfCustom = trailingOfCustomView;
        _topOfCustom = topOfCustomView;
        _bottomOfCustomAndTopOfStack = bottomOfCustomAndTopOfStackView;
    } if (!bottomOfCustomAndTopOfStackView) {
        NSLayoutConstraint *topOfStackView =
        [NSLayoutConstraint constraintWithItem:_contentContainerView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_stackView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:-_padding-_customViewInset.bottom];
        // Add contraint to content view.
        [_contentContainerView addConstraint:topOfStackView];
        // Add reference to the contraint.
        _topOfStackView = topOfStackView;
    }
    NSLayoutConstraint *leadingOfStackView =
    [NSLayoutConstraint constraintWithItem:_contentContainerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_stackView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:-_actionItemMargin];
    NSLayoutConstraint *trailingOfStackView =
    [NSLayoutConstraint constraintWithItem:_contentContainerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_stackView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:_actionItemMargin];
    NSLayoutConstraint *bottomOfStackView =
    [NSLayoutConstraint constraintWithItem:_contentContainerView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_stackView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:.0];
    NSLayoutConstraint *widthOfStackView =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_stackView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                  constant:UIEdgeInsetsGetWidth(_contentInset)+_actionItemMargin*2];
    // Add contraints to the content view.
    [_contentContainerView addConstraints:@[leadingOfStackView, trailingOfStackView, bottomOfStackView]];
    // Add references to the contraints.
    _leadingOfStackView = leadingOfStackView;
    _trailingOfStackView = trailingOfStackView;
    _bottomOfStackView = bottomOfStackView;
    
    [_containerView addConstraint:widthOfStackView];
    _widthOfStackView = widthOfStackView;
    
    [_contentContainerView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [_contentContainerView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
}

- (void)_addContraintsOfEffectViewToContainerView {
    NSLayoutConstraint *leadingOfEffectView =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_effectFlexibleView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:.0];
    NSLayoutConstraint *trailingOfEffectView =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_effectFlexibleView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:.0];
    NSLayoutConstraint *topOfEffectView =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_effectFlexibleView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottomOfEffectAndTopOfStack =
    [NSLayoutConstraint constraintWithItem:_effectFlexibleView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_stackFlexibleView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0.0];
    NSLayoutConstraint *leadingOfStack =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_stackFlexibleView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:.0];
    NSLayoutConstraint *trailingOfStack =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_stackFlexibleView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottomOfStack =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_stackFlexibleView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0 constant:0.0];
    
    [_containerView addConstraints:@[leadingOfEffectView, trailingOfEffectView, topOfEffectView, bottomOfEffectAndTopOfStack, leadingOfStack, trailingOfStack, bottomOfStack]];
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectView)]];
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectView)]];
}

- (void)_updateConfigurationOfItemAtIndex:(NSUInteger)index {
    // Get the button item from the content container view.
    _AXTranslucentButton *buttonItem = [_contentContainerView viewWithTag:index+1];
    // Get the configuration of the configs.
    AXAlertViewActionConfiguration *config = _actionConfig[[NSString stringWithFormat:@"%@", @(index)]];
    // Setup button with configuration.
    [self _setupButtonItem:&buttonItem withConfiguration:config];
}

- (void)_updateConfigurationOfItemForKey:(NSString *)key {
    // Get the button item from the content container view.
    _AXTranslucentButton *buttonItem = [_contentContainerView.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIView * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[_AXTranslucentButton class]]) {
            if ([((_AXTranslucentButton *)evaluatedObject)->_action.identifier isEqualToString:key]) {
                return YES;
            }
        } return NO;
    }]].lastObject;
    if (buttonItem) {
        // Get the configuration of the configs.
        AXAlertViewActionConfiguration *config = _actionConfig[key];
        // Setup button with configuration.
        [self _setupButtonItem:&buttonItem withConfiguration:config];
    }
}

- (void)configureCustomView {
    if (!self.customView) { return; }
    
    if ([[self class] usingAutolayout]) { if (_customView && _customView.superview == self) [_customView removeFromSuperview]; }
    [_contentContainerView addSubview:_customView];
    
    if ([[self class] usingAutolayout]) {
        _customView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_stackView removeFromSuperview];
        [_contentContainerView addSubview:_stackView];
        [self _addContraintsOfCustomViewAndStackViewToContentView];
    }
    
    [self _layoutSubviews];
}

- (void)configureActions {
    // Remove all the older views.
    [_actionButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _actionButtons = [self buttonsWithActions:_actionItems];
    if (_actionButtons.count == 0) return;
    if (_actionButtons.count > _horizontalLimits) {
        if ([[self class] usingAutolayout]) {
            _stackView.axis = UILayoutConstraintAxisVertical;
            _stackView.distribution = UIStackViewDistributionFill;
            _stackView.alignment = UIStackViewAlignmentFill;
            _stackView.spacing = _padding;
            
            [_stackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        if (_translucent) {
            [self _setExceptionAllowedWidth:0.5];
        }
        for (NSInteger i = 0; i < _actionButtons.count ; i++) {
            UIView *object = _actionButtons[i];
            AXAlertViewActionConfiguration *config; 
            if ([object isKindOfClass:[_AXTranslucentButton class]]) {
                NSString *identifier = ((_AXTranslucentButton *)object)->_action.identifier;
                config = _actionConfig[identifier.length?identifier:[NSString stringWithFormat:@"%@", @(i)]];
            } else if ([object respondsToSelector:@selector(identifier)]) {
                NSString *identifier = [object performSelector:@selector(identifier)];
                config = _actionConfig[identifier.length?identifier:[NSString stringWithFormat:@"%@", @(i)]];
            } else {
                config = _actionConfig[NSStringFromClass(object.class)];
            }
            config = config?:_actionConfiguration;
            
            if ([[self class] usingAutolayout]) {
                [object setTranslatesAutoresizingMaskIntoConstraints:NO];
                [object addConstraint:[NSLayoutConstraint constraintWithItem:object attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:config.preferedHeight]];
                
                [_stackView addArrangedSubview:object];
            } else {
                CGFloat beginContext = .0;
                if (i == 0) {
                    beginContext = CGRectGetMaxY(_customView.frame) + _customViewInset.bottom + _padding;
                } else {
                    UIView *lastItem = _actionButtons[i-1];
                    beginContext = CGRectGetMaxY(lastItem.frame) + _actionItemPadding;
                }
                [object setFrame:CGRectMake(_actionItemMargin, beginContext, CGRectGetWidth(_contentContainerView.frame)-_actionItemMargin*2, config.preferedHeight)];
                [self.contentContainerView addSubview:object];
            }
            
            if (![object isMemberOfClass:[_AXAlertContentPlacehodlerView class]]) {
                _AXTranslucentButton *button = (_AXTranslucentButton *)object;
                button.tag = i+1;
                [button addTarget:self action:@selector(handleActionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                if (_showsSeparators) {
                    if (_translucent) [button _setExceptionAllowedWidth:config.separatorHeight direction:0]; else {
                        button->_type = -1;
                        [button _setExceptionSeparatorLayerWidth:config.separatorHeight direction:0];
                    }
                }
            }
            
        } [self _updateFramesOfHookedVeiwsWithContentOffset:_contentContainerView.contentOffset ofScrollView:_contentContainerView];
    } else {
        CGFloat buttonWidth = .0;
        
        if ([[self class] usingAutolayout]) {
            _stackView.axis = UILayoutConstraintAxisHorizontal;
            _stackView.distribution = UIStackViewDistributionFillEqually;
            _stackView.spacing = _actionItemPadding;
        } else {
            buttonWidth = (CGRectGetWidth(_contentContainerView.frame)-_actionItemMargin*2-(_actionItemPadding)*(_actionButtons.count-1))/_actionButtons.count;
        }
        
        if (_translucent) {
            [self _setExceptionAllowedWidth:_showsSeparators?0.5:-0.1];
            [_singleSeparator removeFromSuperview];
        } else {
            if (_showsSeparators) [self _setupExceptionSeparatorLayerWidth:0.5]; else {
                [_singleSeparator removeFromSuperview];
            }
        }
        
        for (NSInteger i = 0; i < _actionButtons.count; i++) {
            UIView *object = _actionButtons[i];
            AXAlertViewActionConfiguration *config;
            if ([object isKindOfClass:[_AXTranslucentButton class]]) {
                NSString *identifier = ((_AXTranslucentButton *)object)->_action.identifier;
                config = _actionConfig[identifier.length?identifier:[NSString stringWithFormat:@"%@", @(i)]];
            } else if ([object respondsToSelector:@selector(identifier)]) {
                NSString *identifier = [object performSelector:@selector(identifier)];
                config = _actionConfig[identifier.length?identifier:[NSString stringWithFormat:@"%@", @(i)]];
            } else {
                config = _actionConfig[NSStringFromClass(object.class)];
            }
            config = config?:_actionConfiguration;
            
            if ([[self class] usingAutolayout]) {
                [object setTranslatesAutoresizingMaskIntoConstraints:NO];
                [object addConstraint:[NSLayoutConstraint constraintWithItem:object attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:config.preferedHeight]];
                [_stackView addArrangedSubview:object];
            } else {
                [object setFrame:CGRectMake(_actionItemMargin+(buttonWidth+_actionItemPadding)*i, CGRectGetHeight(_customView.frame)+_customViewInset.bottom+_padding, buttonWidth, config.preferedHeight)];
                [self.contentContainerView addSubview:object];
            }
            
            if (![object isMemberOfClass:[_AXAlertContentPlacehodlerView class]]) {
                _AXTranslucentButton *button = (_AXTranslucentButton *)object;
                button.tag = i+1;
                [button addTarget:self action:@selector(handleActionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if (_translucent) {
                    if (i < _actionButtons.count-1 && _showsSeparators) [button _setExceptionAllowedWidth:config.separatorHeight direction:3];
                } else {
                    if (i < _actionButtons.count-1 && _showsSeparators) {
                        button->_type = -1;
                        [button _setExceptionSeparatorLayerWidth:config.separatorHeight direction:3];
                    }
                }
            }
        }
    }
}

- (NSArray<_AXTranslucentButton*> *_Nonnull)buttonsWithActions:(NSArray<AXAlertViewAction*> *_Nonnull)actions {
    NSMutableArray *buttons = [@[] mutableCopy];
    for (NSInteger i = 0; i < actions.count; i++) {
        AXAlertViewAction *action = actions[i];
        AXAlertViewActionConfiguration *config;
        if ([action isKindOfClass:[AXAlertViewAction class]]) {
            config = _actionConfig[((AXAlertViewAction *)action).identifier?:[NSString stringWithFormat:@"%@", @(i)]];
        } else {
            config = _actionConfig[NSStringFromClass(action.class)];
        }
        config = config?:_actionConfiguration;
        
        if ([action isMemberOfClass:[AXAlertViewPlaceholderAction class]]) {
            _AXAlertContentPlacehodlerView *placeholder = [_AXAlertContentPlacehodlerView new];
            placeholder.backgroundColor = config.backgroundColor;
            placeholder.identifier = action.identifier;
            [buttons addObject:placeholder];
        } else {
            _AXTranslucentButton *button = [_AXTranslucentButton buttonWithType:UIButtonTypeCustom];
            button->_action = action;
            [button setTitle:[action title] forState:UIControlStateNormal];
            [button setImage:[action image] forState:UIControlStateNormal];
            
            [self _setupButtonItem:&button withConfiguration:config];
            [buttons addObject:button];
        }
    }
    return buttons;
}

- (void)_setupButtonItem:(_AXTranslucentButton **)button withConfiguration:(AXAlertViewActionConfiguration *)config {
    if (!config) {
        config = _actionConfiguration;
    }
    UIColor *backgroundColor = config.backgroundColor;
    if (!backgroundColor) {
        backgroundColor = [self window].tintColor;
    }
    if (!config.translucent || !_translucent) {
        [*button setBackgroundImage:[self rectangleImageWithColor:backgroundColor size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    }
    [*button setBackgroundColor:[UIColor clearColor]];
    [(*button).titleLabel setFont:config.font];
    UIColor *tintColor = config.tintColor;
    if (!tintColor) {
        tintColor = [[self window] tintColor];
    }
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

- (void)_setExceptionAllowedWidth:(CGFloat)arg1 {
    UIView * __block _filterView;
    UIView * __block _backdropView;
    [self.effectView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:NSClassFromString(@"_UIVisualEffectFilterView")]) {
            _filterView = obj;
        } else if ([obj isMemberOfClass:NSClassFromString(@"_UIVisualEffectBackdropView")]) {
            _backdropView = obj;
        }
    }];
    
    if (arg1 < 0.0) {
        _effectMaskLayer = nil; _filterView.layer.mask = nil; [_effectOpacityLayer removeFromSuperlayer]; _effectOpacityLayer = nil; return;
    }
    
    if (_effectOpacityLayer != nil) {
        [_effectOpacityLayer removeFromSuperlayer];
    }
    CGFloat height = 0.0;
    CGFloat _height = 0.0;
    CGFloat _flag = 0.0;
    [self _getHeightOfContentView:&_height flag:&_flag withContentSize:_contentContainerView.contentSize];
    
    if ([[self class] usingAutolayout]) {
        if (_actionItems.count > _horizontalLimits && _height >= _flag) {
            height = CGRectGetMinY([_containerView convertRect:_customView.frame fromView:_contentContainerView]);
        } else {
            height = CGRectGetMinY([_containerView convertRect:_stackView.frame fromView:_contentContainerView]);
        }
    } else {
        height = CGRectGetMinY(_contentContainerView.frame)+_padding+CGRectGetHeight(_customView.frame)/*+_customViewInset.top */+ _customViewInset.bottom;
        if (_actionItems.count > _horizontalLimits && _height >= _flag) {
            height -= CGRectGetHeight(_customView.frame);
            if (_customView) {
                height -= _customViewInset.bottom;
            }
        }
    }

    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)-(_actionItems.count > _horizontalLimits ? .0 : arg1))];
    CAShapeLayer *maskLayrer = [CAShapeLayer layer];
    maskLayrer.path = path.CGPath;
    _filterView.layer.mask = maskLayrer;
    _effectMaskLayer = maskLayrer;
    
    /* CALayer *opacityLayer = [CALayer layer];
    opacityLayer.frame = CGRectMake(0, CGRectGetHeight(frame)-arg1, CGRectGetWidth(frame), arg1);
    _effectOpacityLayer = opacityLayer;
    _effectOpacityLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    [_backdropView.layer addSublayer:_effectOpacityLayer]; */
}

- (void)_setupExceptionSeparatorLayerWidth:(CGFloat)arg1 {
    CGFloat height = 0.0;
    
    if ([[self class] usingAutolayout]) {
        if (_actionItems.count > _horizontalLimits) {
            height = CGRectGetMinY([_containerView convertRect:_customView.frame fromView:_contentContainerView]);
        } else {
            height = CGRectGetMinY([_containerView convertRect:_stackView.frame fromView:_contentContainerView]);
        }
    } else {
        height = CGRectGetMinY(_contentContainerView.frame)+_padding+CGRectGetHeight(_customView.frame)+ _customViewInset.bottom;
        if (_actionItems.count > _horizontalLimits) {
            height -= CGRectGetHeight(_customView.frame);
            if (_customView) {
                height -= _customViewInset.bottom;
            }
        }
    }

    [_singleSeparator removeFromSuperview];
    _AXAlertContentSeparatorView *separator = [_AXAlertContentSeparatorView new];
    [separator setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    [separator setFrame:CGRectMake(0, height-arg1, CGRectGetWidth(_containerView.frame), arg1)];
    [_containerView insertSubview:separator atIndex:0];
    _singleSeparator = separator;
}

- (void)_setupContentHookedView {
    if (_translucent) {
        if (!_contentHeaderView) _contentHeaderView = [_AXAlertContentHeaderView new];
        if (!_contentFooterView) _contentFooterView = [_AXAlertContentFooterView new];
        
        if (_translucentStyle == AXAlertViewTranslucentLight) {
            _contentHeaderView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.8];
            _contentFooterView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.8];
        } else {
            _contentHeaderView.backgroundColor = [UIColor colorWithWhite:0.11 alpha:0.73];
            _contentFooterView.backgroundColor = [UIColor colorWithWhite:0.11 alpha:0.73];
        }
        
        [_contentContainerView insertSubview:_contentFooterView atIndex:0];
        [_contentContainerView insertSubview:_contentHeaderView atIndex:0];
    } else {
        [_contentHeaderView removeFromSuperview];
        [_contentFooterView removeFromSuperview];
    }
}

- (void)_updateHeightConstraintsOfContentView {
    CGFloat height;
    [self _getHeightOfContentView:&height flag:NULL];
    
    [self _updateHeightConstraintsOfContentViewWithHeight:height];
}

- (void)_updateHeightConstraintsOfContentViewWithHeight:(CGFloat)height {
    if (_heightOfContentView) {
        _heightOfContentView.constant = height;
        [_contentContainerView setNeedsUpdateConstraints];
        [_contentContainerView updateConstraintsIfNeeded];
    } else {
        NSLayoutConstraint *heightOfContent = [NSLayoutConstraint constraintWithItem:_contentContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
        [_contentContainerView addConstraint:heightOfContent];
        _heightOfContentView = heightOfContent;
    }
}

- (void)_getHeightOfContentView:(CGFloat *)height flag:(CGFloat *)flag {
    [self _getHeightOfContentView:height flag:flag withContentSize:_contentContainerView.contentSize];
}

- (void)_getHeightOfContentView:(CGFloat *)height flag:(CGFloat *)flag withContentSize:(CGSize)contentSize {
    CGFloat _height = contentSize.height;
    CGFloat _maxAllowed = CGRectGetHeight(self.bounds)-UIEdgeInsetsGetHeight(_preferedMargin)-(CGRectGetHeight(_titleLabel.bounds)+UIEdgeInsetsGetHeight(_titleInset)+UIEdgeInsetsGetHeight(_contentInset)+_padding+_customViewInset.top);
    
    CGFloat _flag = _maxAllowed;
    _height = MIN(_height, _flag);
    if (height != NULL) *height = _height;
    if (flag != NULL) *flag = _flag;
}

- (void)_updateFramesOfHookedVeiwsWithContentOffset:(CGPoint)contentOffset ofScrollView:(UIScrollView *)scrollView {
    
    if (contentOffset.y >= scrollView.contentSize.height-CGRectGetHeight(scrollView.frame)) { // Handle the footer view.
        _contentFooterView.hidden = NO;
        
        CGFloat height = contentOffset.y+CGRectGetHeight(scrollView.frame) - scrollView.contentSize.height;
        [_contentFooterView setFrame:CGRectMake(0, scrollView.contentSize.height, CGRectGetWidth(scrollView.frame), height)];
    } else if (contentOffset.y <= CGRectGetHeight(_customView.frame)+_customViewInset.bottom+_padding) {
        _contentHeaderView.hidden = NO;
        
        CGFloat height = -contentOffset.y+CGRectGetHeight(_customView.frame)+_customViewInset.bottom+_padding;
        [_contentHeaderView setFrame:CGRectMake(0, contentOffset.y, CGRectGetWidth(scrollView.frame), height)];
        [scrollView sendSubviewToBack:_contentHeaderView];
    } else {
        _contentHeaderView.hidden = YES;
        _contentFooterView.hidden = YES;
    }
}

+ (BOOL)usingAutolayout {
    NSString *systemVersion = [[UIDevice currentDevice].systemVersion copy];
    NSArray *comp = [systemVersion componentsSeparatedByString:@"."];
    if (comp.count == 0 || comp.count == 1) {
        systemVersion = [NSString stringWithFormat:@"%@.0.0", systemVersion];
    } else if (comp.count == 2) {
        systemVersion = [NSString stringWithFormat:@"%@.0", systemVersion];
    }
    NSString *plat = [NSString stringWithFormat:@"%@.0.0", @(/*9*/10000/1000)];
    NSComparisonResult result = [systemVersion compare:plat options:NSNumericSearch];
    return result == NSOrderedSame || result == NSOrderedDescending;
}

#pragma mark - UIScrollViewDelegate.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _containerView) {
        CGPoint contentOffset = scrollView.contentOffset;
        _effectView.transform = CGAffineTransformMakeTranslation(0, contentOffset.y);
        _titleLabel.transform = CGAffineTransformMakeTranslation(0, contentOffset.y);
    }
    // Handle content hooked views.
    if (_translucent) {
        [self _updateFramesOfHookedVeiwsWithContentOffset:scrollView.contentOffset ofScrollView:scrollView];
    }
}
@end

@implementation _AXTranslucentButton
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
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    _translucent = YES;
    _translucentStyle = AXAlertViewTranslucentLight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_type == 0) [self _setExceptionAllowedWidth:[_arg1 floatValue] direction:[_arg2 integerValue]]; else {
        [self _setExceptionSeparatorLayerWidth:[_arg1 floatValue] direction:[_arg2 integerValue]];
    }
}

- (UIImageView *)masksView {
    if (_masksView) return _masksView;
    _masksView = [UIImageView new];
    _masksView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    return _masksView;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (_translucent) {
        if (_translucentStyle == AXAlertViewTranslucentLight) {
            self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:highlighted?0.5:0.8];
        } else {
            self.backgroundColor = [UIColor colorWithWhite:0.11 alpha:highlighted?0.5:0.73];
        }
    } else {
        if (highlighted) {
            [self.masksView setFrame:self.bounds];
            [self addSubview:_masksView];
        } else {
            [_masksView removeFromSuperview];
        }
    }
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    if (_translucent) {
        if (_translucentStyle == AXAlertViewTranslucentLight) {
            self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:0.8];
        } else {
            self.backgroundColor = [UIColor colorWithWhite:0.11 alpha:0.73];
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setTranslucentStyle:(AXAlertViewTranslucentStyle)translucentStyle {
    _translucentStyle = translucentStyle;
    
    [self setTranslucent:_translucent];
}

- (void)_setExceptionAllowedWidth:(CGFloat)arg1 direction:(int8_t)arg2 {
    _arg1 = @(arg1); _arg2 = @(arg2);
    
    UIView */* __block */_filterView = self;
    UIView */* __block */_backdropView;
    /* [self.effectView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:NSClassFromString(@"_UIVisualEffectFilterView")]) {
            _filterView = obj;
        } else if ([obj isMemberOfClass:NSClassFromString(@"_UIVisualEffectBackdropView")]) {
            _backdropView = obj;
        }
    }]; */
    // if (!_filterView || !_backdropView) return;
    
    if (arg1 == 0.0 || arg2 < 0) {
        _filterView.layer.mask = nil; _maskLayer = nil; [_opacityLayer removeFromSuperlayer]; _opacityLayer = nil; return;
    }
    
    if (_opacityLayer != nil) {
        [_opacityLayer removeFromSuperlayer];
    }
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    _opacityLayer = layer;
    [_backdropView.layer addSublayer:_opacityLayer];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    _maskLayer = maskLayer;
    
    switch (arg2) {
        case 0: {// Top.
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, arg1, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-arg1)];
            _maskLayer.path = path.CGPath;
            _filterView.layer.mask = _maskLayer;
            _opacityLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), arg1);
            [self setContentEdgeInsets:UIEdgeInsetsMake(arg1, 0, 0, 0)];
        } break;
        case 1: {// Left.
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(arg1, 0, CGRectGetWidth(self.frame)-arg1, CGRectGetHeight(self.frame))];
            _maskLayer.path = path.CGPath;
            _filterView.layer.mask = _maskLayer;
            _opacityLayer.frame = CGRectMake(0, 0, arg1, CGRectGetHeight(self.frame));
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, arg1, 0, 0)];
        } break;
        case 2: {// Bottom.
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-arg1)];
            _maskLayer.path = path.CGPath;
            _filterView.layer.mask = _maskLayer;
            _opacityLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame)-arg1, CGRectGetWidth(self.frame), arg1);
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, arg1, 0)];
        } break;
        case 3: {// Right.
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.frame)-arg1, CGRectGetHeight(self.frame))];
            _maskLayer.path = path.CGPath;
            _filterView.layer.mask = _maskLayer;
            _opacityLayer.frame = CGRectMake(CGRectGetWidth(self.frame)-arg1, 0, arg1, CGRectGetHeight(self.frame));
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, arg1)];
        } break;
        default: _filterView.layer.mask = nil; _maskLayer = nil; [_opacityLayer removeFromSuperlayer]; _opacityLayer = nil; [self setContentEdgeInsets:UIEdgeInsetsZero]; return;
    }
}

- (void)_setExceptionSeparatorLayerWidth:(CGFloat)arg1 direction:(int8_t)arg2 {
    _arg1 = @(arg1); _arg2 = @(arg2);
    
    _AXAlertContentSeparatorView *separatorView = [_AXAlertContentSeparatorView new];
    separatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    switch (arg2) {
        case 0: {// Top.
            [separatorView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), arg1)];
            [self setContentEdgeInsets:UIEdgeInsetsMake(arg1, 0, 0, 0)];
        } break;
        case 1: {// Left.
            [separatorView setFrame:CGRectMake(0, 0, arg1, CGRectGetHeight(self.frame))];
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, arg1, 0, 0)];
        } break;
        case 2: {// Bottom.
            [separatorView setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-arg1, CGRectGetWidth(self.frame), arg1)];
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, arg1, 0)];
        } break;
        case 3: {// Right.
            [separatorView setFrame:CGRectMake(CGRectGetWidth(self.frame)-arg1, 0, arg1, CGRectGetHeight(self.frame))];
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, arg1)];
        } break;
        default: [_singleSeparator removeFromSuperview]; [self setContentEdgeInsets:UIEdgeInsetsZero]; return;
    }
    
    [_singleSeparator removeFromSuperview];
    [self addSubview:separatorView];
    _singleSeparator = separatorView;
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
        _backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        _separatorHeight = 0.5;
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
    config.separatorHeight = self.separatorHeight;
    config.cornerRadius = self.cornerRadius;
    config.preferedHeight = self.preferedHeight;
    config.translucent = self.translucent;
    config.translucentStyle = self.translucentStyle;
    return config;
}
@end

@implementation AXAlertViewPlaceholderAction @end
@implementation AXAlertViewPlaceholderActionConfiguration @end
