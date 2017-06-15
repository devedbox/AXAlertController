//
//  AXAlertView.m
//  AXAlertController
//
//  Created by devedbox on 16/4/5.
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
#import "AXAlertConstant.h"

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
AXAlertViewCustomViewHooks2(_AXAlertViewDimmingView, UIImageView)
AXObserverRemovingViewHooks(_AXAlertViewScrollView, UIScrollView, @[@"contentSize"])
AXAlertPlaceholderViewHooks(_AXAlertContentPlacehodlerView)

static NSString * _kPlatform_info = @"";
CGFloat const kAXAlertVertivalOffsetCenter = 0.0;
CGFloat const kAXAlertVertivalOffsetPinToTop = CGFLOAT_MIN;
CGFloat const kAXAlertVertivalOffsetPinToBottom = CGFLOAT_MAX;

@interface AXAlertView () <UIScrollViewDelegate>
{
    @private
    /// Action buttons. <AXActionSheet> May not being the subclass of UIButton.
    NSArray<__kindof UIButton *> *_actionButtons;
    
    // Transition view of translucent.
    UIView *__weak _translucentTransitionView;
    // Single seprator view added on the container view.
    _AXAlertContentSeparatorView * _singleSeparator;
    /// Underlying background color of the alert view.
    UIColor * _backgroundColor;
    // Contraints.
    NSLayoutConstraint * _leadingOfContainer; // Leading contraint of the container view to self.
    NSLayoutConstraint * _trailingOfContainer; // Trailing contraint of the container view to self.
    NSLayoutConstraint *__weak _heightOfContainer; // Height contraint of the container view to self.
    NSLayoutConstraint *__weak _topOfContainer; // Top contraint of the container view to self.
    NSLayoutConstraint *__weak _bottomOfContainer;// Bottom contraint of the container view to self.
    NSLayoutConstraint * _centerXOfContainer;// Center x contraint of the container view to self.
    NSLayoutConstraint *__weak _centerYOfContainer;// Center y contraint of the container view to self.
    NSLayoutConstraint * _widthOfContainer;// Width contraint of the container view to self.
    
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
    
    NSLayoutConstraint * _equalHeightOfEffectFlexibleAndStack; // Equal height contraint of effect flexible view and stack view.
    NSLayoutConstraint * _heightOfEffectFlexibleView;// Height contraint of the flexible view to the effect view.
    
    /// Mask layer of the effect view.
    CAShapeLayer *_effectMaskLayer;
    
    /// Content header view.
    _AXAlertContentHeaderView *_contentHeaderView;
    /// Content footer view.
    _AXAlertContentFooterView *_contentFooterView;
    
    // Configurations:
    BOOL _needsReconfigureItems;
}
/// Content dimming view.
@property(strong, nonatomic) _AXAlertViewDimmingView *dimmingView;
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
/// Enable and disable the exception area background.
@property(assign, nonatomic) BOOL _shouldExceptContentBackground __deprecated_msg("Using dimming contet image instead.") ;
/// Is the alert view showed on any view.
@property(readonly, nonatomic) BOOL _showedOnView;
@end

@interface _AXTranslucentButton : UIButton {
    /// Mask of the button root view.
    CAShapeLayer *_maskLayer;
    // Single seprator view.
    _AXAlertContentSeparatorView * _singleSeparator;
    
    id _arg1;// CGFloat.
    id _arg2;// CGFloat.
@public
    uint8_t _type;
    /// Alert view acton.
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
- (void)_setExceptionAllowedWidth:(CGFloat)arg1 direction:(int8_t)arg2;// For exception.
- (void)_setExceptionSeparatorLayerWidth:(CGFloat)arg1 direction:(int8_t)arg2;// For addition.
@end

/// Get the 'height' of he inset by adding top and bottom.
static CGFloat UIEdgeInsetsGetHeight(UIEdgeInsets insets) { return insets.top + insets.bottom; }
/// Get the 'width' of the inset by adding left and right.
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
    // self.contentMode = UIViewContentModeCenter;
    
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
    _maxAllowedWidth = 270;
    _cornerRadius = 6;
    _actionConfiguration = [[AXAlertViewActionConfiguration alloc] init];
    _actionConfiguration.backgroundColor = [UIColor colorWithRed:0.996 green:0.725 blue:0.145 alpha:1.00];
    _actionConfiguration.tintColor = [UIColor whiteColor];
    _actionConfiguration.font = [UIFont boldSystemFontOfSize:15];
    _actionConfiguration.cornerRadius = 4;
    _actionConfiguration.preferedHeight = 44.0;
    _actionConfiguration.translucent = YES;
    _verticalOffset = 0.0;
    
    _showsSeparators = YES;
    
    __shouldExceptContentBackground = YES;
    
    super.backgroundColor = [UIColor clearColor];
    // Add dimming view.
    [self addSubview:self.dimmingView];
    // Add contraints of dimming view.
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dimmingView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dimmingView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dimmingView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_dimmingView)]];
    
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
        
        [_containerView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
        [_contentContainerView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:@"_content"];
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
    if ([[self class] usingAutolayout]) {
        [_containerView removeObserver:self forKeyPath:@"bounds"];
        [_contentContainerView removeObserver:self forKeyPath:@"bounds"];
    }
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
                [self _updateSettingsOfContentScrollView];
                // [self _updateFramesOfHookedVeiwsWithContentOffset:_contentContainerView.contentOffset ofScrollView:_contentContainerView];
                // Update transform information of the action buttons.
                // [self _updateTransformOfActionItemsWithContentOffset:_contentContainerView.contentOffset ofScrollView:_contentContainerView];
            } else {
                [_contentHeaderView removeFromSuperview];
                [_contentFooterView removeFromSuperview];
            }
        }
        
        if ([[self class] usingAutolayout]) {
            if (_translucent) {
                if (height >= flag) {
                    if (_heightOfEffectFlexibleView && _equalHeightOfEffectFlexibleAndStack) {
                        [NSLayoutConstraint activateConstraints:@[_heightOfEffectFlexibleView]];
                        [NSLayoutConstraint deactivateConstraints:@[_equalHeightOfEffectFlexibleAndStack]];
                    }
                    
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
                    if (_heightOfEffectFlexibleView && _equalHeightOfEffectFlexibleAndStack) {
                        [NSLayoutConstraint activateConstraints:@[_equalHeightOfEffectFlexibleAndStack]];
                        [NSLayoutConstraint deactivateConstraints:@[_heightOfEffectFlexibleView]];
                    }
                    
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
            // Update height of content scroll view.
            [self _updateHeightConstraintsOfContentViewWithHeight:MAX(0, MIN(height, flag))];
        }
        
        // [self setNeedsDisplay];
        // Replaced with:
        [self _setupContentImageOfDimmingView];
    } else if ([keyPath isEqualToString:@"bounds"]) {
        if (context != NULL) {// Content scroll view.
            [self _updateSettingsOfContentScrollView];
        } else {// Container view.
            // Update exception area of the effect view if bounds of the container view has changed.
            [self _updateExceptionAreaOfEffectView];
            // Update contraints of container view when bounds have changed.
            [self _updateContraintsOfContainer];
            // Redraw the exception background.
            // [self setNeedsDisplay];
            // Replaced with:
            [self _setupContentImageOfDimmingView];
        }
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
        [self configureCustomView];
        
        [self setTranslucent:_translucent];
    } else {
        // Ensure remove the translucent transition view from super view.
        [_translucentTransitionView removeFromSuperview];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    // [self _setupContentImageOfDimmingView];
    /* Using content dimming view instead.
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
     */
}

- (void)layoutSubviews {
    // Call SUPER.
    [super layoutSubviews];
    
    if (![[self class] usingAutolayout]) {
        // Get the current frame of SELF.
        CGRect currentFrame = self.frame;
        // Initialize a CGSize struct of custom view and title label using the current frame and prefered magin and the insets.
        CGSize sizeOfCustomView = CGSizeMake(MIN(CGRectGetWidth(currentFrame)-UIEdgeInsetsGetWidth(_preferedMargin), _maxAllowedWidth) - UIEdgeInsetsGetWidth(_contentInset)-UIEdgeInsetsGetWidth(_customViewInset), 0);
        CGSize sizeOfTitleLabel = CGSizeMake(MIN(CGRectGetWidth(currentFrame)-UIEdgeInsetsGetWidth(_preferedMargin), _maxAllowedWidth) - UIEdgeInsetsGetWidth(_contentInset)-UIEdgeInsetsGetWidth(_titleInset), 0);
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
            if (_actionConfig.count < _actionItems.count) {
                heightOfItems = MAX([[_actionConfig.allValues valueForKeyPath:@"@max.preferedHeight"] floatValue], _actionConfiguration.preferedHeight);
            } else {
                heightOfItems = [[_actionConfig.allValues valueForKeyPath:@"@max.preferedHeight"] floatValue];
            }
            heightOfContainer += _padding;
            heightOfContainer += /*0.5+ */heightOfItems;
        }
        heightOfContainer += _contentInset.bottom;
        
        heightOfContainer = MAX(heightOfContainer, _preferedHeight);
        
        CGFloat preferedLeftMargin = CGRectGetWidth(currentFrame)*.5-_maxAllowedWidth*.5;
        // Frame of container view.
        CGRect rect_container = _containerView.frame;
        rect_container.origin.x = MAX(_preferedMargin.left, preferedLeftMargin);
        
        if (heightOfContainer > CGRectGetHeight(currentFrame)-UIEdgeInsetsGetHeight(_preferedMargin)) { // Too large to show.
            rect_container.origin.y = _preferedMargin.top;
            rect_container.size = CGSizeMake(MIN(CGRectGetWidth(currentFrame)-UIEdgeInsetsGetWidth(_preferedMargin), _maxAllowedWidth), CGRectGetHeight(currentFrame)-UIEdgeInsetsGetHeight(_preferedMargin));
            _containerView.frame = rect_container;
            // Enabled the scroll of the content container view.
            _contentContainerView.scrollEnabled = YES;
            // Set up hooked content view.
            [self _setupContentHookedView];
            
            _effectView.frame = CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), heightOfContainer);
        } else {
            if (_verticalOffset == kAXAlertVertivalOffsetPinToTop) {
                rect_container.origin.y = _preferedMargin.top;
            } else if (_verticalOffset == kAXAlertVertivalOffsetPinToBottom) {
                rect_container.origin.y = CGRectGetHeight(currentFrame) - _preferedMargin.bottom - MIN(heightOfContainer, CGRectGetHeight(currentFrame));
            } else {
                rect_container.origin.y = CGRectGetHeight(currentFrame)*.5-MIN(heightOfContainer, CGRectGetHeight(currentFrame)-UIEdgeInsetsGetHeight(_preferedMargin))*.5+_verticalOffset;
            }
            
            rect_container.size = CGSizeMake(MIN(CGRectGetWidth(currentFrame)-UIEdgeInsetsGetWidth(_preferedMargin), _maxAllowedWidth), MIN(heightOfContainer, CGRectGetHeight(currentFrame)-UIEdgeInsetsGetHeight(_preferedMargin)));
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
        rect_title.size.width = CGRectGetWidth(rect_container)-UIEdgeInsetsGetWidth(_contentInset)-UIEdgeInsetsGetWidth(_titleInset);
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
    
    [self _updateExceptionAreaOfEffectView];
    // Fix on iOS9.0 and higher.
    // if (![[self class] usingAutolayout]) [self _setupActionItems];
    // Replaced with:
    [self _layoutActionButtons:NO];
    // [self setNeedsDisplay];
    // Replaced with:
    [self _setupContentImageOfDimmingView];
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
    if ([[self class] usingAutolayout]) [self _setupActionItems];
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
    if ([[self class] usingAutolayout]) [self _setupActionItems];
}

- (void)show:(BOOL)animated {
    if (_processing) return;
    [self viewWillShow:self animated:animated];
    if (animated) _containerView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.2, 1.2), _containerView.transform);
    __weak typeof(self) wself = self;
    if (animated) [UIView animateWithDuration:0.45 delay:0.00 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:(2 << 16)|(3 << 24)|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionShowHideTransitionViews animations:^{
        _containerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (finished) {
            [wself viewDidShow:wself animated:animated];
        }
    }]; else {
        [self viewDidShow:self animated:NO];
    }
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
}

- (void)hide:(BOOL)animated completion:(AXAlertViewShowsBlock)didHide
{
    _didHide = [didHide copy];
    [self hide:animated];
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

- (_AXAlertViewDimmingView *)dimmingView {
    if (_dimmingView) return _dimmingView;
    _dimmingView = [_AXAlertViewDimmingView new];
    _dimmingView.backgroundColor = [UIColor clearColor];
    _dimmingView.contentMode = UIViewContentModeCenter;
    _dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
    return _dimmingView;
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
        if ([[self class] usingAutolayout]) [self _setupActionItems];
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
            // Removing the stack view and readd the contraints.
            
            [_stackView removeFromSuperview];
            [_contentContainerView addSubview:_stackView];
        
            [self _addContraintsOfCustomViewAndStackViewToContentView];
            // [self setNeedsDisplay];
            // Replaced with:
            [self _setupContentImageOfDimmingView];
        } else {
            // Layout the subviews if needed.
            // [self setNeedsLayout];
            [self _layoutSubviews];
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
    if ([[self class] usingAutolayout]) [self _setupActionItems];
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
    
    [self _setupActionItems];
    // Replaced with:
    // [self _updateExceptionAreaOfEffectView];
    // [self updateConfigurationsOfAllItems];
    // [self _layoutActionButtons:NO];
}

- (void)setShowsSeparators:(BOOL)showsSeparators {
    _showsSeparators = showsSeparators;
    [self _layoutSubviews];
    if ([[self class] usingAutolayout]) [self _setupActionItems];
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
    } else if (!_customView) {
        [self _layoutSubviews];
    }
    
    [self configureCustomView];
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
    if ([[self class] usingAutolayout]) [self _setupActionItems];
}

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    
    if ([[self class] usingAutolayout]) {
        _bottomOfTitleAndTopOfContent.constant = -_titleInset.bottom-_padding-_customViewInset.top;
        _bottomOfCustomAndTopOfStack.constant = -_customViewInset.bottom-_padding;
        _topOfStackView.constant = -_padding-_customViewInset.top;
    }
    
    [self configureCustomView];
}

- (void)setActionItemMargin:(CGFloat)actionItemMargin {
    _actionItemMargin = actionItemMargin;

    if ([[self class] usingAutolayout]) {
        _leadingOfStackView.constant = -_actionItemMargin;
        _trailingOfStackView.constant = _actionItemMargin;
        _widthOfStackView.constant = _contentInset.left+_contentInset.right+_actionItemMargin*2;
    }
    
    [self _setupActionItems];
}

- (void)setVerticalOffset:(CGFloat)verticalOffset {
    _verticalOffset = verticalOffset;
    
    if ([[self class] usingAutolayout]) {
        [self _updatePositionContraintsOfContainer];
        [self setNeedsLayout];
        // [self setNeedsDisplay];
        // Replaced with:
        [self _setupContentImageOfDimmingView];
    } else {
        [self _layoutSubviews];
    }
}

- (void)setActionItemPadding:(CGFloat)actionItemPadding {
    _actionItemPadding = actionItemPadding;

    if ([[self class] usingAutolayout]) {
        [self _setupActionItems];
    } else {
        [self _layoutSubviews];
    }
}

- (void)setHorizontalLimits:(NSInteger)horizontalLimits {
    _horizontalLimits = horizontalLimits;
    // Delays to configure action items at layouting subviews.
    [self _layoutSubviews];
    if ([[self class] usingAutolayout]) [self _setupActionItems];
}

- (void)setOpacity:(CGFloat)opacity {
    _opacity = opacity;
    // [self setNeedsDisplay];
    // Replaced with:
    [self _setupContentImageOfDimmingView];
}

- (void)setPreferedHeight:(CGFloat)preferedHeight {
    _preferedHeight = preferedHeight;

    if ([[self class] usingAutolayout]) {
        _heightOfContainer.constant = _preferedHeight;
    }

    [self configureCustomView];
}

- (void)setPreferedMargin:(AXEdgeMargins)preferedMargin {
    _preferedMargin = preferedMargin;
    
    if ([[self class] usingAutolayout]) {
        _leadingOfContainer.constant = -_preferedMargin.left;
        _trailingOfContainer.constant = _preferedMargin.right;
        _topOfContainer.constant = -_preferedMargin.top;
        _bottomOfContainer.constant = _preferedMargin.bottom;
        
        [self _updateContraintsOfContainer];
    }
    
    [self configureCustomView];
}

- (void)setMaxAllowedWidth:(CGFloat)maxAllowedWidth {
    _maxAllowedWidth = maxAllowedWidth;
    
    if ([[self class] usingAutolayout]) {
        _widthOfContainer.constant = _maxAllowedWidth;
        
        [self _updateContraintsOfContainer];
    }

    [self configureCustomView];
}

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *)actionConfiguration {
    _actionConfiguration = actionConfiguration;
    [self _layoutSubviews];
    if ([[self class] usingAutolayout]) [self _setupActionItems];
}

- (void)set_shouldExceptContentBackground:(BOOL)_shouldExceptContentBackground {
    __shouldExceptContentBackground = _shouldExceptContentBackground;
    // [self setNeedsDisplay];
    // Replaced with:
    [self _setupContentImageOfDimmingView];
}

#pragma mark - Actions
- (void)handleDeviceOrientationDidChangeNotification:(NSNotification *)aNote {
    // BOOL animated = [[[aNote userInfo] objectForKey:@"UIDeviceOrientationRotateAnimatedUserInfoKey"] boolValue];
    [self _handleDeviceOrientationDidChangeWithoutAnimated];
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
    
    // [self.layer removeAllAnimations];
    // [self.containerView.layer removeAllAnimations];
    
    _processing = YES;
    
    if (_willShow != NULL && _willShow != nil) {
        _willShow(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillShow:)]) {
        [_delegate alertViewWillShow:self];
    }
}

- (void)viewDidShow:(AXAlertView *)alertView animated:(BOOL)animated {
    // [self.layer removeAllAnimations];
    // [self.containerView.layer removeAllAnimations];
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
    // [self.layer removeAllAnimations];
    // [self.containerView.layer removeAllAnimations];
    // Remove the former from the container view if exits.
    if (_translucentTransitionView.superview == self.containerView) {
        [_translucentTransitionView removeFromSuperview];
    }
    
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
    // [self.layer removeAllAnimations];
    // [self.containerView.layer removeAllAnimations];
    [_translucentTransitionView removeFromSuperview];
    
    _processing = NO;
    
    if (_didHide != NULL && _didHide != nil) {
        _didHide(self, animated);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidHide:)]) {
        [_delegate alertViewDidHide:self];
    }
}

#pragma mark - Configuration.
- (void)setNeedsReconfigureItems {
    _needsReconfigureItems = YES;
}

- (void)reconfigureItemsIfNeeded {
    if (_needsReconfigureItems) [self configureActions];
}

- (void)_setupActionItems {
    [self setNeedsReconfigureItems];
    [self reconfigureItemsIfNeeded];
}

- (void)updateConfigurationsOfAllItems {
    for (int i = 0; i < _actionButtons.count; i ++) {
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
        
        [self _setupButtonItem:&object withConfiguration:config];
    }
}

- (void)configureCustomView {
    if (!self.customView) { return; }
    
    if ([[self class] usingAutolayout]) { if (_customView && _customView.superview == _contentContainerView) [_customView removeFromSuperview]; }
    [_contentContainerView addSubview:_customView];
    
    if ([[self class] usingAutolayout]) {
        _customView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_stackView removeFromSuperview];
        [_contentContainerView addSubview:_stackView];
        [self _addContraintsOfCustomViewAndStackViewToContentView];
    }
    
    [self _layoutSubviews];
    [self _setupActionItems];
}

- (void)configureActions {
    // Remove all the older views.
    [_actionButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // Initialize all new action buttons.
    _actionButtons = [self buttonsWithActions:_actionItems];
    
    if (_actionButtons.count == 0) return;
    // Layout and update contraints of actions.
    [self _layoutActionButtons:YES];
}

- (void)_layoutActionButtons:(BOOL)updateContraints {
    [self _updateExceptionAreaOfEffectView];
    
    if (_actionButtons.count > _horizontalLimits) {
        if ([[self class] usingAutolayout]) {
            if (updateContraints) {
                _stackView.axis = UILayoutConstraintAxisVertical;
                _stackView.distribution = UIStackViewDistributionFill;
                _stackView.alignment = UIStackViewAlignmentFill;
                _stackView.spacing = _actionItemPadding;
                
                [_stackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }
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
                if (updateContraints) {
                    [object setTranslatesAutoresizingMaskIntoConstraints:NO];
                    [object addConstraint:[NSLayoutConstraint constraintWithItem:object attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:config.preferedHeight]];
                    
                    [_stackView addArrangedSubview:object];
                }
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
                    if (_translucent) {
                        button->_type = 0;
                        [button _setExceptionAllowedWidth:config.separatorHeight direction:0];
                    } else {
                        button->_type = -1;
                        [button _setExceptionSeparatorLayerWidth:config.separatorHeight direction:0];
                    }
                } else {
                    if (_translucent) {
                        button->_type = 0;
                        [button _setExceptionAllowedWidth:.0 direction:0];
                    } else {
                        button->_type = -1;
                        [button _setExceptionSeparatorLayerWidth:0 direction:0];
                    }
                }
            }
            
        } if (![[self class] usingAutolayout])[self _updateFramesOfHookedVeiwsWithContentOffset:_contentContainerView.contentOffset ofScrollView:_contentContainerView];
    } else {
        CGFloat buttonWidth = .0;
        
        if ([[self class] usingAutolayout]) {
            if (updateContraints) {
                _stackView.axis = UILayoutConstraintAxisHorizontal;
                _stackView.distribution = UIStackViewDistributionFillEqually;
                _stackView.spacing = _actionItemPadding;
            }
        } else {
            buttonWidth = (CGRectGetWidth(_contentContainerView.frame)-_actionItemMargin*2-(_actionItemPadding)*(_actionButtons.count-1))/_actionButtons.count;
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
                if (updateContraints) {
                    [object setTranslatesAutoresizingMaskIntoConstraints:NO];
                    [object addConstraint:[NSLayoutConstraint constraintWithItem:object attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:config.preferedHeight]];
                    [_stackView addArrangedSubview:object];
                }
            } else {
                [object setFrame:CGRectMake(_actionItemMargin+(buttonWidth+_actionItemPadding)*i, CGRectGetHeight(_customView.frame)+_customViewInset.bottom+_padding, buttonWidth, config.preferedHeight)];
                [self.contentContainerView addSubview:object];
            }
            
            if (![object isMemberOfClass:[_AXAlertContentPlacehodlerView class]]) {
                _AXTranslucentButton *button = (_AXTranslucentButton *)object;
                button.tag = i+1;
                [button addTarget:self action:@selector(handleActionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if (_translucent) {
                    if (_showsSeparators && i < _actionButtons.count-1) {
                        button->_type = 0;
                        [button _setExceptionAllowedWidth:config.separatorHeight direction:3];
                    } else {
                        button->_type = 0;
                        [button _setExceptionAllowedWidth:0.0 direction:3];
                    }
                } else {
                    if (_showsSeparators && i < _actionButtons.count-1) {
                        button->_type = -1;
                        [button _setExceptionSeparatorLayerWidth:config.separatorHeight direction:3];
                    } else {
                        button->_type = -1;
                        [button _setExceptionSeparatorLayerWidth:0.0 direction:3];
                    }
                }
            }
        }
        // There may be a larger content size of the content scroll view when added the custom view, so update the transform of the action buttons if needed.
        if (![[self class] usingAutolayout]) [self _updateTransformOfActionItemsWithContentOffset:_contentContainerView.contentOffset ofScrollView:_contentContainerView];
    }
}
#pragma mark - Access to private.
/// Access to `_processing` for the module.
- (BOOL)processing { return _processing; }

#pragma mark - Private
/// Set needs layout subviews.
- (void)_layoutSubviews {
    if (![self _showedOnView]) return;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
/// Animate to handle device orientation changing.
- (void)_handleDeviceOrientationDidChangeByAnimated {
    [self _handleDeviceOrientationDidChangeAnimated:YES];
}
/// Handle device orientation changing wiithout animation.
- (void)_handleDeviceOrientationDidChangeWithoutAnimated {
    [self _handleDeviceOrientationDidChangeAnimated:NO];
}

- (void)_handleDeviceOrientationDidChangeAnimated:(BOOL)animated {
    if (![[self class] usingAutolayout]) {
        if (animated) [UIView animateWithDuration:0.25 animations:^{
            [self _updateSettingsOfContentScrollView];
        }]; else {
            [self _updateSettingsOfContentScrollView];
        }
    } else {
        if (animated) [UIView animateWithDuration:0.25 animations:^{
            [self _updateContraintsOfContainer];
        }]; else {
            [self _updateContraintsOfContainer];
        }
    }
    
    // Using dimming content image instead:
    // [self set_shouldExceptContentBackground:NO];
    // [self performSelector:@selector(_enabled_shouldExceptContentBackground) withObject:nil afterDelay:0.3];
    
    [self _layoutSubviews];
    // [self _setupActionItems];
    // Replaced with:
    [self _layoutActionButtons:NO];
}

- (void)_disable_shouldExceptContentBackground __deprecated_msg("Using dimming contet image instead.") {
    [self set_shouldExceptContentBackground:NO];
}

- (void)_enabled_shouldExceptContentBackground __deprecated_msg("Using dimming contet image instead.") {
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
    NSLayoutConstraint *widthOfContainer =
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:_maxAllowedWidth];
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
    NSLayoutConstraint *centerXOfContainer =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeCenterX
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
    [self addConstraints:@[leadingOfContainer, trailingOfContainer/*, heightOfContainer*/, centerYOfContainer, /* topOfContainer, bottomOfContainer*/centerXOfContainer, widthOfContainer]];
    
    [_containerView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    // Add references to the contraints.
    _leadingOfContainer = leadingOfContainer;
    _trailingOfContainer = trailingOfContainer;
    _heightOfContainer = heightOfContainer;
    _topOfContainer = topOfContainer;
    _bottomOfContainer = bottomOfContainer;
    _centerXOfContainer = centerXOfContainer;
    _widthOfContainer = widthOfContainer;
    _centerYOfContainer = centerYOfContainer;
    
    [self _updateContraintsOfContainer];
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

- (void)_setupButtonItem:(UIView **)itemView withConfiguration:(AXAlertViewActionConfiguration *)config {
    config = config?:_actionConfiguration;
    
    UIColor *backgroundColor = config.backgroundColor?:[self window].tintColor;
    
    [(*itemView) setBackgroundColor:[UIColor clearColor]];
    (*itemView).layer.cornerRadius = config.cornerRadius;
    (*itemView).layer.masksToBounds = YES;
    
    if ([*itemView isKindOfClass:[_AXTranslucentButton class]]) {
        _AXTranslucentButton *button = (_AXTranslucentButton *)*itemView;
        if (!config.translucent || !_translucent) {
            [button setBackgroundImage:[self rectangleImageWithColor:backgroundColor size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }
        [button.titleLabel setFont:config.font];
        UIColor *tintColor = config.tintColor ?: [[self window] tintColor];
        
        [button setTitleColor:tintColor forState:UIControlStateNormal];
        button.translucent = config.translucent&&_translucent;
        button.translucentStyle = config.translucentStyle;
    }
}

- (UIImage *)rectangleImageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
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
        //!!!: Fixs _UIVisualEffectSubview class on the iOS 11.0 developer beta1.0.
        if (/*[obj isMemberOfClass:NSClassFromString(@"_UIVisualEffectFilterView")]*/[[NSPredicate predicateWithFormat:@"SELF MATCHES[cd] '_UIVisualEffectFilterView' OR SELF MATCHES[cd] '_UIVisualEffectSubview'"] evaluateWithObject:NSStringFromClass(obj.class)]) {
            _filterView = obj;
        } else if ([obj isMemberOfClass:NSClassFromString(@"_UIVisualEffectBackdropView")]) {
            _backdropView = obj;
        }
    }];
    
    if (arg1 < 0.0) {
        _effectMaskLayer = nil; _filterView.layer.mask = nil; return;
    }
    
    CGFloat height = 0.0;
    CGFloat _height = 0.0;
    CGFloat _flag = 0.0;
    [self _getHeightOfContentView:&_height flag:&_flag withContentSize:_contentContainerView.contentSize];
    
    if ([[self class] usingAutolayout]) {
        if (_actionItems.count > _horizontalLimits && _height >= _flag) {
            height = CGRectGetMinY([_containerView convertRect:_customView.frame fromView:_contentContainerView])+_contentContainerView.contentOffset.y;
        } else {
            height = CGRectGetHeight(_containerView.bounds)-CGRectGetHeight(_stackView.bounds)-_contentInset.bottom;
            // CGAffineTransform transform = _stackView.transform;
            // _stackView.transform = CGAffineTransformIdentity;
            // if (_height >= _flag) {
                // height = CGRectGetMinY([_containerView convertRect:_stackView.frame fromView:_contentContainerView])-(_contentContainerView.contentSize.height-CGRectGetHeight(_contentContainerView.frame));
            // } else {
                // height = CGRectGetMinY([_containerView convertRect:_stackView.frame fromView:_contentContainerView]);
            // }
            // _stackView.transform = transform;
        }
    } else {
        height = CGRectGetMinY(_contentContainerView.frame)+_padding+CGRectGetHeight(_customView.frame)/*+_customViewInset.top */+ _customViewInset.bottom;
        if (_actionItems.count > _horizontalLimits && _height >= _flag) {
            height -= CGRectGetHeight(_customView.frame);
            if (_customView) {
                height -= _customViewInset.bottom;
            }
        } else if (_height >= _flag) {
            height -= (_contentContainerView.contentSize.height-CGRectGetHeight(_contentContainerView.frame));
        }
    }

    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(_containerView.frame), height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)-(_actionItems.count > _horizontalLimits ? .0 : arg1))];
    CAShapeLayer *maskLayrer = _effectMaskLayer?:[CAShapeLayer layer];
    maskLayrer.frame = frame;
    maskLayrer.path = path.CGPath;
    _filterView.layer.mask = nil;
    _filterView.layer.mask = maskLayrer;
    if (!_effectMaskLayer) _effectMaskLayer = maskLayrer;
}

- (void)_setupExceptionSeparatorLayerWidth:(CGFloat)arg1 {
    CGFloat height = 0.0;
    CGFloat _height = 0.0;
    CGFloat _flag = 0.0;
    [self _getHeightOfContentView:&_height flag:&_flag withContentSize:_contentContainerView.contentSize];
    
    if ([[self class] usingAutolayout]) {
        if (_actionItems.count > _horizontalLimits) {
            height = CGRectGetMinY([_containerView convertRect:_customView.frame fromView:_contentContainerView]);
        } else {
            // height = CGRectGetMinY([_containerView convertRect:_stackView.frame fromView:_contentContainerView]);
            height = CGRectGetHeight(_containerView.bounds)-CGRectGetHeight(_stackView.bounds)-_contentInset.bottom;
        }
    } else {
        height = CGRectGetMinY(_contentContainerView.frame)+_padding+CGRectGetHeight(_customView.frame)+ _customViewInset.bottom;
        if (_actionItems.count > _horizontalLimits) {
            height -= CGRectGetHeight(_customView.frame);
            if (_customView) {
                height -= _customViewInset.bottom;
            }
        } else if (_height >= _flag) {
            height -= (_contentContainerView.contentSize.height-CGRectGetHeight(_contentContainerView.frame));
        }
    }
    
    _AXAlertContentSeparatorView *separator = _singleSeparator?:[_AXAlertContentSeparatorView new];
    [separator setHidden:NO];
    [separator setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    if (separator.superview != _containerView) [_containerView insertSubview:separator atIndex:0];
    CGRect frameOfSingleSeparator = CGRectMake(0, height-arg1, CGRectGetWidth(_containerView.frame), arg1);
    if (!CGRectEqualToRect(frameOfSingleSeparator, separator.frame)) {
        [separator setFrame:frameOfSingleSeparator];
    }
    if (!_singleSeparator) _singleSeparator = separator;
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
    if (_actionItems.count > _horizontalLimits) {
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
    } else {
        _contentHeaderView.hidden = YES;
        _contentFooterView.hidden = YES;
    }
}

- (void)_updateTransformOfActionItemsWithContentOffset:(CGPoint)contentOffset ofScrollView:(UIScrollView *)scrollView {
    CGFloat _height = 0.0;
    CGFloat _flag = 0.0;
    [self _getHeightOfContentView:&_height flag:&_flag withContentSize:_contentContainerView.contentSize];
    
    CGFloat visibleHeight = 0.0;
    void(^maskCustomView)(CGFloat) = ^(CGFloat height) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, contentOffset.y, CGRectGetWidth(_customView.frame), height)];
        if (!_customView.layer.mask) {
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = path.CGPath;
            _customView.layer.mask = maskLayer;
        } else {
            ((CAShapeLayer *)_customView.layer.mask).path = path.CGPath;
        }
    };
    
    if ([[self class] usingAutolayout]) {
        visibleHeight = CGRectGetHeight(scrollView.bounds)-CGRectGetHeight(_stackView.bounds)-_padding-_customViewInset.bottom;
        
        if (_actionItems.count <= _horizontalLimits && _height >= _flag) {
            _stackView.transform = CGAffineTransformMakeTranslation(0, contentOffset.y-(scrollView.contentSize.height-CGRectGetHeight(scrollView.bounds)));
            maskCustomView(visibleHeight);
        } else if (!CGAffineTransformIsIdentity(_stackView.transform)) {
            _stackView.transform = CGAffineTransformIdentity;
            _customView.layer.mask = nil;
        } else {
            _customView.layer.mask = nil;
        }
    } else {
        if (_actionConfig.count < _actionItems.count) visibleHeight = CGRectGetHeight(scrollView.frame)-MAX([[_actionConfig.allValues valueForKeyPath:@"@max.preferedHeight"] floatValue], _actionConfiguration.preferedHeight)-_padding-_customViewInset.bottom; else visibleHeight = CGRectGetHeight(scrollView.frame)-[[_actionConfig.allValues valueForKeyPath:@"@max.preferedHeight"] floatValue]-_padding-_customViewInset.bottom;
        
        if (_actionItems.count <= _horizontalLimits && _height >= _flag) {
            for (UIView *_acView in _actionButtons) {
                CGRect frame = _acView.frame;
                frame.origin.y = CGRectGetHeight(scrollView.frame)+scrollView.contentOffset.y-CGRectGetHeight(frame);
                _acView.frame = frame;
            }
            maskCustomView(visibleHeight);
        } else if (!CGAffineTransformIsIdentity(((UIView *)[NSSet setWithArray:_actionButtons].anyObject).transform)) {
            for (UIView *_acView in _actionButtons) {
                _acView.transform = CGAffineTransformIdentity;
            }
        } else {
            _customView.layer.mask = nil;
        }
    }
}

+ (BOOL)usingAutolayout { /*return NO;*/
    if (_kPlatform_info.length > 0) {
        return [_kPlatform_info isEqualToString:@"autolayout_true"];
    }
    if (AX_ALERT_AVAILABLE_ON_PLATFORM([NSString stringWithFormat:@"%@.0.0", @(9000/1000)])) {
        _kPlatform_info = @"autolayout_true";  return YES;
    } else {
        _kPlatform_info = @"autolayout_false"; return NO;
    }
}
/// Updating the contraints of container if needed. Configurations for the max alowed width.
- (void)_updateContraintsOfContainer {
    if (_maxAllowedWidth <= CGRectGetWidth(self.bounds)-UIEdgeInsetsGetWidth(_preferedMargin)) {
        [NSLayoutConstraint deactivateConstraints:@[_leadingOfContainer, _trailingOfContainer]];
        [NSLayoutConstraint activateConstraints:@[_widthOfContainer, _centerXOfContainer]];
    } else {
        [NSLayoutConstraint deactivateConstraints:@[_widthOfContainer, _centerXOfContainer]];
        [NSLayoutConstraint activateConstraints:@[_leadingOfContainer, _trailingOfContainer]];
    }
}
/// Updating exception area of effect view by remask the layer of the filter view of the effect view.
- (void)_updateExceptionAreaOfEffectView {
    if (_actionButtons.count > _horizontalLimits) {
        if (_translucent) {
            [self _setExceptionAllowedWidth:0.5];
        } [_singleSeparator setHidden:YES];
    } else {
        if (_translucent) {
            [self _setExceptionAllowedWidth:_showsSeparators?0.5:0.0];
            [_singleSeparator setHidden:YES];
        } else {
            if (_showsSeparators) [self _setupExceptionSeparatorLayerWidth:0.5]; else {
                [_singleSeparator setHidden:YES];
            }
        }
    }
}
/// - Updating frames of hooked views if translucent.
/// - Updating transform of action item buttons.
- (void)_updateSettingsOfContentScrollView {
    [self _updateSettingsOfScrollView:_contentContainerView];
}
- (void)_updateSettingsOfScrollView:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    // Handle content hooked views.
    if (_translucent) {
        [self _updateFramesOfHookedVeiwsWithContentOffset:contentOffset ofScrollView:scrollView];
    }
    // Pin the stack view of needed.
    [self _updateTransformOfActionItemsWithContentOffset:contentOffset ofScrollView:scrollView];
}

- (void)_updatePositionContraintsOfContainer {
    if (_verticalOffset == kAXAlertVertivalOffsetPinToTop) {
        if (_centerYOfContainer) [NSLayoutConstraint deactivateConstraints:@[_centerYOfContainer]];
        
        if (_topOfContainer) {
            [self removeConstraint:_topOfContainer];
        }
        NSLayoutConstraint *topOfContainer =
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_containerView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:-_preferedMargin.top];
        [self addConstraint:topOfContainer];
        _topOfContainer = topOfContainer;
    } else if (_verticalOffset == kAXAlertVertivalOffsetPinToBottom) {
        if (_centerYOfContainer) [NSLayoutConstraint deactivateConstraints:@[_centerYOfContainer]];
        
        if (_bottomOfContainer) {
            [self removeConstraint:_bottomOfContainer];
        }
        NSLayoutConstraint *bottomOfContainer =
        [NSLayoutConstraint constraintWithItem:self
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_containerView
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:_preferedMargin.bottom];
        [self addConstraint:bottomOfContainer];
        _bottomOfContainer = bottomOfContainer;
    } else {
        // [self _reconfigureVerticalPositionConstraintsOfContainer];
        if (_topOfContainer) [self removeConstraint:_topOfContainer];
        if (_bottomOfContainer) [self removeConstraint:_bottomOfContainer];
        if (!_centerYOfContainer) {
            NSLayoutConstraint *centerYOfContainer =
            [NSLayoutConstraint constraintWithItem:self
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:_containerView
                                         attribute:NSLayoutAttributeCenterY
                                        multiplier:1.0
                                          constant:0.0];
            [self addConstraint:centerYOfContainer];
            _centerXOfContainer = centerYOfContainer;
        }
        [NSLayoutConstraint activateConstraints:@[_centerYOfContainer]];
        CGFloat height = 0.0;
        CGFloat flag = 0.0;
        [self _getHeightOfContentView:&height flag:&flag];
        if (height < flag) {
            _centerYOfContainer.constant = -MIN(flag-height, _verticalOffset);
        }
    }
}

- (void)_reconfigureVerticalPositionConstraintsOfContainer __deprecated {
    if (_topOfContainer) [self removeConstraint:_topOfContainer];
    if (_bottomOfContainer) [self removeConstraint:_bottomOfContainer];
    NSLayoutConstraint *bottomOfContainer =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:_preferedMargin.bottom];
    [self addConstraint:bottomOfContainer];
    _bottomOfContainer = bottomOfContainer;
    NSLayoutConstraint *topOfContainer =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-_preferedMargin.top];
    [self addConstraint:topOfContainer];
    _topOfContainer = topOfContainer;
    [self updateConstraints];
}

- (UIImage *)_dimmingKnockoutImageOfFrameOfContainerView {
    return [[self class] _dimmingKnockoutImageOfExceptionRect:self.containerView.frame cornerRadius:_cornerRadius inRect:self.bounds opacity:_opacity];
}

+ (UIImage *)_dimmingKnockoutImageOfExceptionRect:(CGRect)exceptionRect cornerRadius:(CGFloat)cornerRadius inRect:(CGRect)mainBounds opacity:(CGFloat)opacity {
    CGFloat maxElements = MAX(CGRectGetWidth(mainBounds), CGRectGetHeight(mainBounds))*2;
    CGSize size = CGSizeMake(maxElements, maxElements);
    UIColor *drawingColor = [UIColor colorWithWhite:0 alpha:opacity];
    UIColor *clearingColor = [UIColor clearColor];
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    CGPathRef outterPath = CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height), nil);
    CGContextAddPath(context, outterPath);
    CGContextSetFillColorWithColor(context, drawingColor.CGColor);
    CGContextFillPath(context);
    
    CGPathRelease(outterPath);
    
    CGRect exceptionFrame = exceptionRect;
    exceptionFrame.origin.x += size.width*.5-CGRectGetWidth(mainBounds)*.5;
    exceptionFrame.origin.y += size.height*.5-CGRectGetHeight(mainBounds)*.5;
    
    if (CGRectGetWidth(exceptionFrame) < cornerRadius*2 || CGRectGetHeight(exceptionFrame) < cornerRadius*2) return nil;
    CGPathRef innerPath = CGPathCreateWithRoundedRect(exceptionFrame, cornerRadius, cornerRadius, nil);
    CGContextAddPath(context, innerPath);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextSetFillColorWithColor(context, clearingColor.CGColor);
    CGContextFillPath(context);
    
    CGPathRelease(innerPath);
    // CGContextDrawImage(context, self.bounds, nil);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)_setupContentImageOfDimmingView {
    UIImage *image = [self _dimmingKnockoutImageOfFrameOfContainerView];
    if (image != nil) {
        _dimmingView.image = image;
    }
}

#pragma mark - UIScrollViewDelegate.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self _updateSettingsOfScrollView:scrollView];
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
    
    if (_type == 0) {// Layout mask layer.
        [self _setupFrameOfMaskLayer];
    } else {// Layout separator view.
        [self _setupFrameOfSeparator];
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (_type == 0) [self _setupFrameOfMaskLayer];
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
    
    if (arg1 <= 0.0 || arg2 < 0) {// Show no mask layer.
        self.layer.mask = nil;
        _maskLayer = nil;
        return;
    }
    
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
    }
    
    [self _setupFrameOfMaskLayer];
}

- (void)_setupFrameOfMaskLayer {
    if (!_maskLayer) return;
    switch ([_arg2 integerValue]) {
        case 0: {// Top.
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, [_arg1 floatValue], CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-[_arg1 floatValue])];
            _maskLayer.path = path.CGPath;
            self.layer.mask = _maskLayer;
            [self setContentEdgeInsets:UIEdgeInsetsMake([_arg1 floatValue], 0, 0, 0)];
        } break;
        case 1: {// Left.
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake([_arg1 floatValue], 0, CGRectGetWidth(self.frame)-[_arg1 floatValue], CGRectGetHeight(self.frame))];
            _maskLayer.path = path.CGPath;
            self.layer.mask = _maskLayer;
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, [_arg1 floatValue], 0, 0)];
        } break;
        case 2: {// Bottom.
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-[_arg1 floatValue])];
            _maskLayer.path = path.CGPath;
            self.layer.mask = _maskLayer;
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, [_arg1 floatValue], 0)];
        } break;
        case 3: {// Right.
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.frame)-[_arg1 floatValue], CGRectGetHeight(self.frame))];
            _maskLayer.path = path.CGPath;
            self.layer.mask = _maskLayer;
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, [_arg1 floatValue])];
        } break;
        default: self.layer.mask = nil; _maskLayer = nil; [self setContentEdgeInsets:UIEdgeInsetsZero]; return;
    }
}

- (void)_setExceptionSeparatorLayerWidth:(CGFloat)arg1 direction:(int8_t)arg2 {
    _arg1 = @(arg1); _arg2 = @(arg2);
    
    if (!_singleSeparator) {
        _singleSeparator = [_AXAlertContentSeparatorView new];
        _singleSeparator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:_singleSeparator];
    } if (arg1 <= 0.0) {
        _singleSeparator.hidden = YES;
    } else {
        _singleSeparator.hidden = NO;
    }
    
    [self _setupFrameOfSeparator];
}

- (void)_setupFrameOfSeparator {
    if (!_singleSeparator || _singleSeparator.hidden) return;
    switch ([_arg2 integerValue]) {
        case 0: {// Top.
            [_singleSeparator setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), [_arg1 floatValue])];
            [self setContentEdgeInsets:UIEdgeInsetsMake([_arg1 floatValue], 0, 0, 0)];
        } break;
        case 1: {// Left.
            [_singleSeparator setFrame:CGRectMake(0, 0, [_arg1 floatValue], CGRectGetHeight(self.frame))];
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, [_arg1 floatValue], 0, 0)];
        } break;
        case 2: {// Bottom.
            [_singleSeparator setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-[_arg1 floatValue], CGRectGetWidth(self.frame), [_arg1 floatValue])];
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, [_arg1 floatValue], 0)];
        } break;
        case 3: {// Right.
            [_singleSeparator setFrame:CGRectMake(CGRectGetWidth(self.frame)-[_arg1 floatValue], 0, [_arg1 floatValue], CGRectGetHeight(self.frame))];
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, [_arg1 floatValue])];
        } break;
        default: [_singleSeparator removeFromSuperview]; [self setContentEdgeInsets:UIEdgeInsetsZero]; return;
    }
    // Bring the separator to the front.
    [self bringSubviewToFront:_singleSeparator];
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
