//
//  AXAlertView.h
//  AXAlertView
//
//  Created by ai on 16/4/5.
//  Copyright © 2016年 devedbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AXAlertViewAction;
@class AXAlertViewActionConfiguration;

/// UIAlertController
@interface AXAlertView : UIView
/// Title text color. Default is #FEB925.
@property(strong, nonatomic, nullable) UIColor *titleColor UI_APPEARANCE_SELECTOR;
/// Text font of title. Default is system bold 17 pt.
@property(strong, nonatomic, nullable) UIFont *titleFont UI_APPEARANCE_SELECTOR;
/// Translucent. Default is YES.
@property(assign, nonatomic) BOOL translucent UI_APPEARANCE_SELECTOR;
/// Content inset.
@property(assign, nonatomic) UIEdgeInsets contentInset UI_APPEARANCE_SELECTOR;
/// Custom view inset.
@property(assign, nonatomic) UIEdgeInsets customViewInset UI_APPEARANCE_SELECTOR;
/// Content padding.
@property(assign, nonatomic) CGFloat padding UI_APPEARANCE_SELECTOR;
/// Horizontal action item limits.
///
/// @discusstion This is a limits of horizontal action item. If the count of actions is more than the limits count, the action will show vertically.
@property(assign, nonatomic) NSInteger horizontalLimits UI_APPEARANCE_SELECTOR;
/// Custom view.
@property(weak, nonatomic, nullable) IBOutlet UIView *customView;

- (void)addActions:(AXAlertViewAction *_Nonnull)actions,...;
@end

typedef void(^AXAlertViewActionHandler)(AXAlertViewAction *_Nonnull action);

@interface AXAlertViewAction : NSObject
/// Title
@property(readonly, nonatomic, nonnull) NSString *title;
/// Handler call back block. If handler is null, then the handler is dismiss by default.
@property(copy, nonatomic, nullable) AXAlertViewActionHandler handler;

+ (instancetype _Nonnull)actionWithTitle:(NSString *_Nonnull)title handler:(AXAlertViewActionHandler _Nullable)handler;
@end

@interface AXAlertViewActionConfiguration : NSObject
/// Font of title.
@property(strong, nonatomic, nullable) UIFont *font;
/// Text color of title.
@property(strong, nonatomic, nullable) UIColor *textColor;
/// Background color.
@property(readonly, nonatomic, nonnull) UIColor *backgroundColor;
@end