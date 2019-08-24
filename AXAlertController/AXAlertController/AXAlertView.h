//
//  AXAlertView.h
//  AXAlertController
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

#import <UIKit/UIKit.h>

@class AXAlertViewAction;
@class AXAlertViewActionConfiguration;
@class AXAlertView;

NS_ASSUME_NONNULL_BEGIN
@protocol AXAlertViewDelegate <NSObject>
@optional
/// Called when the alert view is about to show in the container view.
- (void)alertViewWillShow:(AXAlertView *)alertView;
/// Called when the alert view did show in the container view.
- (void)alertViewDidShow:(AXAlertView *)alertView;
/// Called when the alert view is about to hide from the container view.
- (void)alertViewWillHide:(AXAlertView *)alertView;
/// Called when the alert view did hide from the container view.
- (void)alertViewDidHide:(AXAlertView *)alertView;
@end

/// Defines the block callback when alert view is animating showing or hidding instead of using delegate.
/// The block call back can eixst with the delegate.
typedef void(^AXAlertViewShowsBlock)(AXAlertView *alertView, BOOL animated);
/// Defines the block callback when the alert view is touched.
typedef void(^AXAlertViewTouchBlock)(AXAlertView *alertView);

/// A enum type represents the translucent style of the alert view.
typedef NS_ENUM(NSInteger, AXAlertViewTranslucentStyle) {
    /// The light translucent style.
    AXAlertViewTranslucentLight,
    /// The dark translucent style.
    AXAlertViewTranslucentDark
};

typedef UIEdgeInsets AXEdgeMargins;

/// Bounds of the container view remain in the center.
extern CGFloat const kAXAlertVertivalOffsetCenter;
/// Bounds of the container view pin to the top.
extern CGFloat const kAXAlertVertivalOffsetPinToTop;
/// Bounds of the container view pin to the bottom.
extern CGFloat const kAXAlertVertivalOffsetPinToBottom;

/// UIAlertController
@interface AXAlertView : UIView {
    @protected
    /// Is animation processing.
    BOOL _processing;
    /// Action items.
    NSMutableArray<AXAlertViewAction *> *_actionItems;
    /// Configuration for action items.
    NSMutableDictionary<NSString*, AXAlertViewActionConfiguration*> *_actionConfig;
}
/// Delegate.
@property(weak, nonatomic, nullable) id<AXAlertViewDelegate>delegate;
/// Title label.
@property(readonly, nonatomic) UILabel *titleLabel;
/// Title text color. Default is #FEB925.
@property(strong, nonatomic, nullable) UIColor *titleColor UI_APPEARANCE_SELECTOR;
/// Text font of title. Default is system bold 17 pt.
@property(strong, nonatomic, nullable) UIFont *titleFont UI_APPEARANCE_SELECTOR;
/// Translucent. Default is YES.
@property(assign, nonatomic) BOOL translucent UI_APPEARANCE_SELECTOR;
/// Hide alert view on touch. Defaults to NO.
@property(assign, nonatomic) BOOL hidesOnTouch UI_APPEARANCE_SELECTOR;
/// Show the separator view or not. Defaults to YES.
@property(assign, nonatomic) BOOL showsSeparators UI_APPEARANCE_SELECTOR;
/// Translucent style. Default is Light.
@property(assign, nonatomic) AXAlertViewTranslucentStyle translucentStyle UI_APPEARANCE_SELECTOR;
/// Content inset. Defaults to (0, 0, 0, 0)
@property(assign, nonatomic) UIEdgeInsets contentInset UI_APPEARANCE_SELECTOR;
/// Custom view inset. Defaults to (0, 10, 10, 10)
@property(assign, nonatomic) UIEdgeInsets customViewInset UI_APPEARANCE_SELECTOR;
/// Title label content inset. Defaults to (10, 10, 10, 10).
@property(assign, nonatomic) UIEdgeInsets titleInset UI_APPEARANCE_SELECTOR;
/// Content padding. Defaults to 10.
@property(assign, nonatomic) CGFloat padding UI_APPEARANCE_SELECTOR;
/// Action items padding. Defalt is 0.
@property(assign, nonatomic) CGFloat actionItemPadding UI_APPEARANCE_SELECTOR;
/// Action items margin. Default is 0.
@property(assign, nonatomic) CGFloat actionItemMargin UI_APPEARANCE_SELECTOR;
/// Offset on the vertical direction. Defaults to 0.0;
@property(assign, nonatomic) CGFloat verticalOffset UI_APPEARANCE_SELECTOR;
/// Horizontal action item limits. Defaults to 2.
///
/// @discusstion This is a limits of horizontal action item. If the count of actions is more than the limits count, the action will show vertically.
@property(assign, nonatomic) NSInteger horizontalLimits UI_APPEARANCE_SELECTOR;
/// Opacity of the dimed background. Value between [0, 1]. Defaults to 0.4.
@property(assign, nonatomic) CGFloat opacity UI_APPEARANCE_SELECTOR;
/// Content preferred height. Default is 0.
@property(assign, nonatomic) CGFloat preferredHeight UI_APPEARANCE_SELECTOR __deprecated;
/// Content preferred edge margin. Default is 40.
@property(assign, nonatomic) AXEdgeMargins preferredMargin UI_APPEARANCE_SELECTOR;
/// Max width of the alert view. Default is 270.
@property(assign, nonatomic) CGFloat maxAllowedWidth UI_APPEARANCE_SELECTOR;
/// Corner radius. Default is 6.
@property(assign, nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
/// Custom view. Defaults to nil.
@property(strong, nonatomic, nullable) IBOutlet UIView *customView;
/// Title of alert view. Defaults to nil.
@property(nonatomic, nullable) NSString *title;
/// Action item configuration. This is a default configuration of all action item.
@property(strong, nonatomic, nonnull) AXAlertViewActionConfiguration *actionConfiguration UI_APPEARANCE_SELECTOR;
/// Alert view will show block.
@property(copy, nonatomic, nullable) AXAlertViewShowsBlock willShow;
/// Alert view did show block.
@property(copy, nonatomic, nullable) AXAlertViewShowsBlock didShow;
/// Alert view will hide.
@property(copy, nonatomic, nullable) AXAlertViewShowsBlock willHide;
/// Alert view did hide.
@property(copy, nonatomic, nullable) AXAlertViewShowsBlock didHide;
/// Alert view did touch.
@property(copy, nonatomic, nullable) AXAlertViewTouchBlock touch;
/// Content view, shows the content of alert title and message and custom view.
@property(readonly, nonatomic, nullable) UIView *contentView;
/// Actions.
@property(readonly, nonatomic, copy, nullable) NSArray<AXAlertViewAction *> *actionItems;
/// Set the actions of the alert view with replacing of the old ones.
/// @discusstion Using this method to update the actions if you want to
///              replace the old actions with new actions.
///
/// @param actions The actions to replace the old ones of A Mutable-Length va_list.
///
- (void)setActions:(__kindof AXAlertViewAction *_Nonnull)actions,...;
- (void)appendActions:(__kindof AXAlertViewAction *_Nonnull)actions,...;

- (void)show:(BOOL)animated;
- (void)show:(BOOL)animated completion:(AXAlertViewShowsBlock _Nullable)didShow;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated completion:(AXAlertViewShowsBlock _Nullable)didHide;

- (void)setActionConfiguration:(AXAlertViewActionConfiguration *_Nonnull)configuration
                        forKey:(NSString *_Nonnull)key UI_APPEARANCE_SELECTOR;
- (void)setActionConfiguration:(AXAlertViewActionConfiguration *_Nonnull)configuration
                forItemAtIndex:(NSUInteger)index;
- (void)setActionConfiguration:(AXAlertViewActionConfiguration *_Nonnull)configuration
                     forAction:(AXAlertViewAction *_Nonnull)action;

- (void)viewWillShow:(AXAlertView *)alertView animated:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidShow:(AXAlertView *)alertView animated:(BOOL)animated NS_REQUIRES_SUPER;

- (void)viewWillHide:(AXAlertView *)alertView animated:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidHide:(AXAlertView *)alertView animated:(BOOL)animated NS_REQUIRES_SUPER;

@end

@interface AXAlertView (Configurations)

- (void)setNeedsReconfigureItems;
- (void)reconfigureItemsIfNeeded;

@end

typedef void(^AXAlertViewActionHandler)(AXAlertViewAction *__weak _Nonnull action);

@interface AXAlertViewAction : NSObject
/// Key for the configuration.
@property(copy, nonatomic, nullable) NSString *identifier;
/// Title
@property(readonly, nonatomic, nonnull) NSString *title;
/// Image.
@property(readonly, nonatomic, nullable) UIImage *image;
/// Handler call back block. If handler is null, then the handler is dismiss by default.
@property(copy, nonatomic, nullable) AXAlertViewActionHandler handler;

+ (instancetype _Nonnull)actionWithTitle:(NSString *_Nonnull)title
                                 handler:(AXAlertViewActionHandler _Nullable)handler;
+ (instancetype _Nonnull)actionWithTitle:(NSString *_Nonnull)title
                                   image:(UIImage *_Nullable)image
                                 handler:(AXAlertViewActionHandler _Nullable)handler;
@end

#pragma mark - AXAlertViewActionConfiguration.

/// The configuration of the alert action.
@interface AXAlertViewActionConfiguration : NSObject <NSCopying>
/// Font of title.
@property(strong, nonatomic, nullable) UIFont  *font;
/// Text color of title.
@property(strong, nonatomic, nullable) UIColor *tintColor;
/// Background color.
@property(strong, nonatomic, nonnull)  UIColor *backgroundColor;
/// preferred height. Only used for default configuration.
@property(assign, nonatomic) CGFloat heightForLayout;
/// Separator height.
@property(assign, nonatomic) CGFloat heightForSeparator;
/// Corner radius.
@property(assign, nonatomic) CGFloat cornerRadius;
/// Translucent of the action item. Defailts to YES.
@property(assign, nonatomic, getter=isTranslucent) BOOL translucent;
/// Translucent style. Defaults to Light.
@property(assign, nonatomic) AXAlertViewTranslucentStyle translucentStyle;
@end

@interface AXAlertViewPlaceholderAction : AXAlertViewAction @end
@interface AXAlertViewPlaceholderActionConfiguration : AXAlertViewActionConfiguration @end

NS_ASSUME_NONNULL_END
