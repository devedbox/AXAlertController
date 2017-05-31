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

@interface AXActionSheet () <UIScrollViewDelegate> {
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
    va_list args;
    va_start(args, actions);
    AXAlertViewAction *action;
    _actionItems = [@[] mutableCopy];
    [_actionItems addObject:actions];
    while ((action = va_arg(args, AXAlertViewAction *))) {
        [_actionItems addObject:action];
    }
    va_end(args);
    // Resort the actions.
    [_actionItems filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[AXActionSheetAction class]]) {
            return YES;
        } else {
            return NO;
        }
    }]];
    [_actionItems sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"style" ascending:YES]]];
    [self _addupPlaceholderAction];
    // Delays to configure action items at layouting subviews.
    if (!_processing && self.superview != nil) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)appendActions:(AXActionSheetAction *)actions, ... {
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
    [_actionItems filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject isKindOfClass:[AXActionSheetAction class]]) {
            return YES;
        } else {
            return NO;
        }
    }]];
    [_actionItems sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"style" ascending:YES]]];
    [self _addupPlaceholderAction];
    // Delays to configure action items at layouting subviews.
    if (!_processing && self.superview != nil) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *)configuration forItemAtIndex:(NSUInteger)index {
    [super setActionConfiguration:configuration forItemAtIndex:index];
    
    [self _addupPlaceholderAction];
}

- (void)setTranslucent:(BOOL)translucent {
    [super setTranslucent:translucent];
    
    [self _addupPlaceholderAction];
}

- (void)setTranslucentStyle:(AXAlertViewTranslucentStyle)translucentStyle {
    [super setTranslucentStyle:translucentStyle];
    
    [self _addupPlaceholderAction];
}

#pragma mark - UIScrollViewDelegate.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([super respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [super performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
    }
    
    AXAlertViewAction *action = _actionItems.lastObject;
    if ([action isKindOfClass:[AXActionSheetAction class]]) {
        AXActionSheetAction *_sheetAction = (AXActionSheetAction *)action;
        if (_sheetAction.style == AXActionSheetActionStyleCancel) {
            // Pin the cancel action.
            // ...
        }
    }
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

- (void)_addupPlaceholderAction {
    if (_actionItems.count >= 2) {
        if ([_actionItems[_actionItems.count-2] isKindOfClass:[AXAlertViewPlaceholderAction class]]) {
            [_actionItems removeObjectAtIndex:_actionItems.count-2];
        }
    }
    if ([_actionItems indexOfObjectPassingTest:^BOOL(AXAlertViewAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((AXActionSheetAction *)obj).style == AXActionSheetActionStyleCancel) {
            *stop = YES;
            return YES;
        } else {
            return NO;
        }
    }] != NSNotFound) {
        if ([_actionItems.lastObject isKindOfClass:[AXActionSheetAction class]]) {
            NSString *key = [NSString stringWithFormat:@"%@", @(_actionItems.count-1)];
            if (_actionConfig[key] != nil) {
                [_actionConfig setObject:_actionConfig[key] forKey:[NSString stringWithFormat:@"%@", @(_actionItems.count)]];
            }
            
            AXAlertViewPlaceholderActionConfiguration *config = [AXAlertViewPlaceholderActionConfiguration new];
            config.preferedHeight = 10;
            if (self.translucent) {
                if (self.translucentStyle == AXAlertViewTranslucentLight) {
                    config.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0.7];
                } else {
                    config.backgroundColor = [UIColor colorWithWhite:0.11 alpha:0.6];
                }
            } else {
                config.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.8];
            }
            
            [_actionConfig setObject:config forKey:@"cancel_placeholder"];
            
            AXAlertViewPlaceholderAction *placeholder = [AXAlertViewPlaceholderAction new];
            placeholder.identifier = @"cancel_placeholder";
            [_actionItems insertObject:placeholder atIndex:_actionItems.count-1];
        }
    }
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
