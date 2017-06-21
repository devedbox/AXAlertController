//
//  SettingViewController.h
//  AXAlertController
//
//  Created by devedbox on 2017/6/21.
//  Copyright © 2017年 devedbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXAlertController.h"

@class SettingViewController;
@class SettingModel;
@protocol SettingViewControllerDelegate
- (SettingModel *)originalSettingModel;
- (void)settingViewControllerDidFinishConfiguring:(SettingModel *)settingModel;
@end

@interface SettingViewController : UITableViewController
@property(assign, nonatomic) id<SettingViewControllerDelegate> delegate;
@end

@interface SettingModel: NSObject
#pragma mark - Normal.
@property(assign, nonatomic) BOOL translucent;
@property(assign, nonatomic) AXAlertViewTranslucentStyle translucentStyle;
@property(assign, nonatomic) BOOL hidesOnTouch;
@property(assign, nonatomic) BOOL showsSeparators;
@property(assign, nonatomic) CGFloat padding;
@property(assign, nonatomic) CGFloat verticalOffset;
@property(assign, nonatomic) CGFloat opacity;
@property(assign, nonatomic) CGFloat maxAllowedWidth;
@property(assign, nonatomic) CGFloat cornerRadius;
#pragma mark - Actions.
@property(assign, nonatomic) BOOL actionTranslucent;
@property(assign, nonatomic) AXAlertViewTranslucentStyle actionTranslucentStyle;
@property(assign, nonatomic) CGFloat actionPadding;
@property(assign, nonatomic) CGFloat actionMargin;
#pragma mark - Insets.
@property(assign, nonatomic) UIEdgeInsets preferedMargin;
@property(assign, nonatomic) UIEdgeInsets contentInset;
@property(assign, nonatomic) UIEdgeInsets customViewInset;
@property(assign, nonatomic) UIEdgeInsets titleInset;
@end
