//
//  AXActionSheet.m
//  AXAlertView
//
//  Created by devedbox on 2017/5/28.
//  Copyright © 2017年 devedbox. All rights reserved.
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

#import "AXActionSheet.h"

#ifndef AXAlertViewUsingAutolayout
#define AXAlertViewUsingAutolayout (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0)
// #define AXAlertViewUsingAutolayout 1
#endif

@interface AXAlertView (SubclassHooks)
- (void)initializer;

+ (BOOL)usingAutolayout;
@end

@interface AXActionSheet () {
    NSMutableArray<AXActionSheetAction *> *_actions;
}

@property(strong, nonatomic) UIView *animatingView;
@end

@implementation AXActionSheet
#pragma mark - Life cycle
- (void)initializer {
    [super initializer];
    super.horizontalLimits = 0;
    super.preferedMargin = UIEdgeInsetsMake(64, 0, 0, 0);
    super.cornerRadius = .0;
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
}

- (void)dealloc {}

#pragma mark - Override.
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect_container = self.contentView.frame;
    rect_container.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(rect_container);
    self.contentView.frame = rect_container;
}

- (void)viewWillShow:(AXAlertView *)alertView animated:(BOOL)animated {
    [super viewWillShow:alertView animated:animated];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self _addupAnimatingViewWithHeight:-0.1];
}

- (void)show:(BOOL)animated {
    if (self->_processing) return;
    [self viewWillShow:self animated:animated];
    __weak typeof(self) wself = self;
    
#if AXAlertViewUsingAutolayout
    self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.frame));
#else
    CGRect frame = self.contentView.frame;
    frame.origin.y = CGRectGetHeight(self.bounds);
    self.contentView.frame = frame;
#endif
    CGRect rect = _animatingView.frame; rect.size.height = 0.0;
    if (animated) [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:7 animations:^{
#if AXAlertViewUsingAutolayout
        self.contentView.transform = CGAffineTransformIdentity;
#else
        [self setNeedsLayout];
        [self layoutIfNeeded];
#endif
        [_animatingView setFrame:rect];
    } completion:^(BOOL finished) {
        if (finished) {
            [wself viewDidShow:wself animated:animated];
        }
    }]; else {
        [self viewDidShow:self animated:NO];
    }
}

- (void)viewDidShow:(AXAlertView *)alertView animated:(BOOL)animated {
    [super viewDidShow:alertView animated:animated];
    
    // [self.animatingView removeFromSuperview];
}

- (void)viewWillHide:(AXAlertView *)alertView animated:(BOOL)animated {
    [super viewWillHide:alertView animated:animated];
    
    // [self _addupAnimatingViewWithHeight:.0];
}

- (void)hide:(BOOL)animated {
    if (self->_processing) return;
    [self viewWillHide:self animated:animated];
    __weak typeof(self) wself = self;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGRect frame = self.contentView.frame;
#if AXAlertViewUsingAutolayout
    self.contentView.transform = CGAffineTransformIdentity;
#else
    CGRect rect = frame;
    rect.origin.y = CGRectGetHeight(self.bounds);
#endif
    if (animated) [UIView animateWithDuration:0.25 delay:0.0 options:7 animations:^{
#if AXAlertViewUsingAutolayout
        self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(frame));
#else
        self.contentView.frame = rect;
#endif
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [wself viewDidHide:self animated:animated];
        }
    }]; else {
        [self viewDidHide:self animated:NO];
    }
}

- (void)viewDidHide:(AXAlertView *)alertView animated:(BOOL)animated {
    [super viewDidHide:alertView animated:animated];
    
    self.alpha = 1.0;
    self.contentView.transform = CGAffineTransformIdentity;
    [self.animatingView removeFromSuperview];
}

- (void)setActions:(AXActionSheetAction *)actions, ... {
    NSAssert([actions isKindOfClass:[AXActionSheetAction class]], @"Action sheet should using `AXActionSheetAction` as actions.");
    va_list args;
    va_start(args, actions);
    AXActionSheetAction *_last;
    AXActionSheetAction *action;
    if (actions.style == AXActionSheetActionStyleDefault) {
        [super appendActions:actions, nil];
    } else {
        _last = actions;
    }
    
    while ((action = va_arg(args, AXActionSheetAction *))) {
        NSAssert([actions isKindOfClass:[AXActionSheetAction class]], @"Action sheet should using `AXActionSheetAction` as actions.");
        if (action.style == AXActionSheetActionStyleDefault) {
            [super appendActions:action, nil];
        } else {
            _last = action;
        }
    }
    va_end(args);
    if (_last) [super appendActions:_last, nil];
}

- (void)appendActions:(AXActionSheetAction *)actions, ... {
    NSAssert([actions isKindOfClass:[AXActionSheetAction class]], @"Action sheet should using `AXActionSheetAction` as actions.");
    va_list args;
    va_start(args, actions);
    AXActionSheetAction *action;
    if (actions.style == AXActionSheetActionStyleDefault) {
        [super appendActions:actions, nil];
    }
    while ((action = va_arg(args, AXActionSheetAction *))) {
        NSAssert([actions isKindOfClass:[AXActionSheetAction class]], @"Action sheet should using `AXActionSheetAction` as actions.");
        [super appendActions:action, nil];
    }
    va_end(args);
    [self setActions:_actions?:@[]];
}

#pragma mark - Getters.
- (UIView *)animatingView {
    if (_animatingView) return _animatingView;
    _animatingView = [UIView new];
    return _animatingView;
}
#pragma mark - Setters.
- (void)setHorizontalLimits:(NSInteger)horizontalLimits {
    [super setHorizontalLimits:0];
}

- (void)setPreferedMargin:(AXEdgeMargins)preferedMargin {
    [super setPreferedMargin:UIEdgeInsetsMake(64, 0, 0, 0)];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [super setCornerRadius:.0];
}

#pragma mark - Private.
- (void)_addupAnimatingViewWithHeight:(CGFloat)height {
    [self.animatingView setFrame:self.contentView.frame];
    [_animatingView setBackgroundColor:[UIColor colorWithWhite:0 alpha:self.opacity]];
    [_animatingView.layer setCornerRadius:self.cornerRadius];
    [_animatingView.layer setMasksToBounds:YES];
    if (height >= 0) {
        CGRect rect = _animatingView.frame;
        rect.size.height = height;
        _animatingView.frame = rect;
    }
    [self insertSubview:_animatingView belowSubview:self.contentView];
}
@end

@implementation AXActionSheetAction
+ (instancetype)actionWithTitle:(NSString *)title style:(AXActionSheetActionStyle)style handler:(AXAlertViewActionHandler)handler {
    AXActionSheetAction *action = [super actionWithTitle:title handler:handler];
    action.style = style;
    return action;
}

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image style:(AXActionSheetActionStyle)style handler:(AXAlertViewActionHandler)handler {
    AXActionSheetAction *action = [super actionWithTitle:title image:image handler:handler];
    action.style = style;
    return action;
}
@end
