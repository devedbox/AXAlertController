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

@interface AXAlertView (SubclassHooks)
- (void)initializer;
@end

@interface AXActionSheet () {
    NSMutableArray<AXActionSheetAction *> *_actions;
}

@property(readonly, nonatomic) UIView *_containerView;
@end

@implementation AXActionSheet
#pragma mark - Life cycle
- (void)initializer {
    [super initializer];
    super.horizontalLimits = 0;
    super.preferedMargin = 0.0;
}

- (void)dealloc {}

#pragma mark - Override.
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect_container = self._containerView.frame;
    rect_container.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(rect_container);
    self._containerView.frame = rect_container;
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
- (UIView *)_containerView { return [self valueForKeyPath:@"containerView"]; }

#pragma mark - Setters.
- (void)setHorizontalLimits:(NSInteger)horizontalLimits {
    [super setHorizontalLimits:0];
}

- (void)setPreferedMargin:(CGFloat)preferedMargin {
    [super setPreferedMargin:.0];
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
