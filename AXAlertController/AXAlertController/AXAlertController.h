//
//  AXAlertController.h
//  AXAlertController
//
//  Created by devedbox on 2017/5/27.
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

#import <UIKit/UIKit.h>
#import "AXAlertView.h"
#import "AXActionSheet.h"
NS_ASSUME_NONNULL_BEGIN
@class AXAlertAction;

typedef NS_ENUM(NSInteger, AXAlertControllerStyle) {
    AXAlertControllerStyleActionSheet = 0,
    AXAlertControllerStyleAlert
};

typedef NS_ENUM(NSInteger, AXAlertActionStyle) {
    AXAlertActionStyleDefault = 0,
    AXAlertActionStyleCancel
};

typedef void(^AXAlertActionHandler)(AXAlertAction *__weak _Nonnull action);
@interface AXAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(nullable NSString *)title handler:(nullable AXAlertActionHandler)handler;

@property(copy, nonatomic, nullable) NSString *identifier;
@property(readonly, nonatomic, nullable) NSString *title;
@property(readonly, nonatomic) AXAlertActionStyle style;
@end

@interface AXAlertAction (Extensions)
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(AXAlertActionStyle)style handler:(nullable AXAlertActionHandler)handler;
+ (instancetype)actionWithTitle:(nullable NSString *)title image:(nullable UIImage *)image style:(AXAlertActionStyle)style handler:(nullable AXAlertActionHandler)handler;
@end

@interface AXAlertActionConfiguration : AXAlertViewActionConfiguration @end

@interface AXAlertController : UIViewController
/// Alert view.
@property(readonly, nonatomic) AXAlertView *alertView;

@property(nullable, nonatomic, copy) NSString *title;
@property(nullable, nonatomic, copy) NSString *message;
@property (nonatomic, readonly) NSArray<AXAlertAction *> *actions;

@property(readonly, nonatomic) AXAlertControllerStyle preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(AXAlertControllerStyle)preferredStyle;

- (void)addAction:(AXAlertAction *)action;
@end

@interface AXAlertController (Configuration)
- (void)addAction:(AXAlertAction *)action configuration:(nullable AXAlertActionConfiguration *)config;
- (void)addAction:(AXAlertAction *)action configurationHandler:(void (^__nullable)(AXAlertActionConfiguration *config))configuration;
@end

@interface AXAlertController (Image)
@property(nonatomic, nullable) UIImage *image;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message image:(nullable UIImage *)image preferredStyle:(AXAlertControllerStyle)preferredStyle;
@end

@interface AXAlertController (TextField)
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@end
NS_ASSUME_NONNULL_END
