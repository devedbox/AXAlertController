//
//  SampleViewController.m
//  AXAlertController
//
//  Created by devedbox on 2017/6/20.
//  Copyright © 2017年 devedbox. All rights reserved.
//

#import "SampleViewController.h"
#import "SettingViewController.h"
#import "AXAlertController.h"

@interface SampleViewController () <SettingViewControllerDelegate>
/// Setting model.
@property(strong, nonatomic) SettingModel *settings;
@end

@interface SampleTableViewCell: UITableViewCell {
    UIView *_highlightedView;
}
@end
@implementation SampleTableViewCell
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (!_highlightedView) {
        _highlightedView = [UIView new];
        _highlightedView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0.77];
    }
    [_highlightedView setFrame:self.bounds];
    
    if (highlighted) {
        [self insertSubview:_highlightedView atIndex:0];
        if (animated) {
            _highlightedView.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                _highlightedView.alpha = 1.0;
            }];
        }
    } else {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                _highlightedView.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [_highlightedView removeFromSuperview];
                    _highlightedView.alpha = 1.0;
                }
            }];
        } else {
            [_highlightedView removeFromSuperview];
        }
    }
}
@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIImage *image = [UIImage imageNamed:@"Image"];
    UIView *backgroundView = [[UIImageView alloc] initWithImage:image];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = backgroundView;
    
    _settings = [SettingModel new];
    _settings.translucent = YES;
    _settings.translucentStyle = AXAlertViewTranslucentLight;
    _settings.hidesOnTouch = NO;
    _settings.showsSeparators = YES;
    _settings.padding = 0.0;
    _settings.verticalOffset = 0.0;
    _settings.opacity = 0.0;
    _settings.maxAllowedWidth = 270;
    _settings.cornerRadius = 12.0;
    _settings.actionTranslucent = YES;
    _settings.actionTranslucentStyle = AXAlertViewTranslucentLight;
    _settings.actionPadding = 0.0;
    _settings.actionMargin = 0.0;
    _settings.preferedMargin = UIEdgeInsetsMake(0, 25, 0, 25);
    _settings.contentInset = UIEdgeInsetsZero;
    _settings.customViewInset = UIEdgeInsetsMake(5, 15, 20, 15);
    _settings.titleInset = UIEdgeInsetsMake(20, 16, 0, 16);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"settings"]) {
        SettingViewController *settingViewController = (SettingViewController *)(((UINavigationController *)segue.destinationViewController).topViewController);
        settingViewController.delegate = self;
    }
    
    [super prepareForSegue:segue sender:sender];
}
#pragma mark - UITableViewDelegate.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {// Show normal.
            [self showNormal:cell];
        } break;
        case 1: {// With image.
            [self showWithImage:cell];
        } break;
        case 2: {// With single textfield.
            [self showWithSingleTextfield:cell];
        } break;
        case 3: {// With image and single textfield.
            [self showWithImageAndSingleTextfield:cell];
        } break;
        case 4: {// With multiple text fields.
            [self showWithMultipleTextfields:cell];
        } break;
        case 5: {// With multiple actions.
            [self showWithMultipleActions:cell];
        } break;
        case 6: {// With multiple textfields and actions.
            [self showWithMultipleTextfieldsAndActions:cell];
        } break;
        case 7: {// Scrollable image content.
            [self showScrollableImageContent:cell];
        } break;
        case 8: {// Scrollable message content.
            [self showScrollableMessageContent:cell];
        } break;
        default:
            break;
    }
}

#pragma mark - Actions.
- (IBAction)showNormal:(id)sender {
    [self presentViewController:[self _normalAlertController] animated:YES completion:NULL];
}

- (IBAction)showWithImage:(id)sender {
    AXAlertController *alert = [self _normalAlertController];
    [alert configureImageViewWithHandler:^(UIImageView * _Nonnull imageView) {
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [self _resizedTouchImage];
    }];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)showWithSingleTextfield:(id)sender {
    AXAlertController *alert = [self _normalAlertController];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Type text...";
    }];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)showWithImageAndSingleTextfield:(id)sender {
    AXAlertController *alert = [self _normalAlertController];
    [alert configureImageViewWithHandler:^(UIImageView * _Nonnull imageView) {
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [self _resizedTouchImage];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Type text...";
    }];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)showWithMultipleTextfields:(id)sender {
    AXAlertController *alert = [self _normalAlertController];
    [alert configureImageViewWithHandler:^(UIImageView * _Nonnull imageView) {
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [self _resizedTouchImage];
    }];
    for (int i = 0; i < 5; i++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Type text...";
        }];
    }
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)showWithMultipleActions:(id)sender {
    AXAlertController *alert = [self _normalAlertController];
    [alert configureImageViewWithHandler:^(UIImageView * _Nonnull imageView) {
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [self _resizedTouchImage];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Type text...";
    }];
    for (int i = 0; i<4; i++) {
        [alert addAction:[AXAlertAction actionWithTitle:@"OK" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
            config.translucent = _settings.actionTranslucent;
            config.translucentStyle = _settings.actionTranslucentStyle;
            
            config.font = [UIFont systemFontOfSize:17];
            config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
        }];
    }
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)showWithMultipleTextfieldsAndActions:(id)sender {
    AXAlertController *alert = [self _normalAlertController];
    [alert configureImageViewWithHandler:^(UIImageView * _Nonnull imageView) {
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [self _resizedTouchImage];
    }];
    for (int i = 0; i < 3; i++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Type text...";
        }];
    }
    for (int i = 0; i < 3; i++) {
        [alert addAction:[AXAlertAction actionWithTitle:@"OK" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
            config.translucent = _settings.actionTranslucent;
            config.translucentStyle = _settings.actionTranslucentStyle;
            
            config.font = [UIFont systemFontOfSize:17];
            config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
        }];
    }
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)showScrollableImageContent:(id)sender {
    AXAlertController *alert = [self _normalAlertController];
    [alert configureImageViewWithHandler:^(UIImageView * _Nonnull imageView) {
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"content_image"];
    }];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)showScrollableMessageContent:(id)sender {
    AXAlertController *alert = [self _normalAlertController];
    alert.message = @"The iPhone has shipped with a camera since its first model. In the first SDKs, the only way to integrate the camera within an app was by using UIImagePickerController, but iOS 4 introduced the AVFoundation framework, which allowed more flexibility.\n\nIn this article, we’ll see how image capture with AVFoundation works, how to control the camera, and the new features recently introduced in iOS 8.\n\nUIImagePickerController provides a very simple way to take a picture. It supports all the basic features, such as switching to the front-facing camera, toggling the flash, tapping on an area to lock focus and exposure, and, on iOS 8, adjusting the exposure just as in the system camera app.\n\nHowever, when direct access to the camera is necessary, the AVFoundation framework allows full control, for example, for changing the hardware parameters programmatically, or manipulating the live preview.\n\nAn image capture implemented with the AVFoundation framework is based on a few classes. These classes give access to the raw data coming from the camera device and can control its components.\n\nNow we need a camera device input. On most iPhones and iPads, we can choose between the back camera and the front camera — aka the selfie camera. So first we have to iterate over all the devices that can provide video data (the microphone is also an AVCaptureDevice, but we’ll skip it) and check for the position property\n\nNote that the first time the app is executed, the first call to AVCaptureDeviceInput.deviceInputWithDevice() triggers a system dialog, asking the user to allow usage of the camera. This was introduced in some countries with iOS 7, and was extended to all regions with iOS 8. Until the user accepts the dialog, the camera input will send a stream of black frames.";
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - SettingViewControllerDelegate.
- (SettingModel *)originalSettingModel { return _settings; }
- (void)settingViewControllerDidFinishConfiguring:(SettingModel *)settingModel {
    _settings = settingModel;
}

#pragma mark - Private.
- (AXAlertController *)_normalAlertController {
    AXAlertController *alert = [AXAlertController alertControllerWithTitle:@"Some title..." message:@"Some message..." preferredStyle:AXAlertControllerStyleAlert];
    // Set up alert.
    alert.alertView.translucent = _settings.translucent;
    alert.alertView.translucentStyle = _settings.translucentStyle;
    alert.alertView.hidesOnTouch = _settings.hidesOnTouch;
    alert.alertView.showsSeparators = _settings.showsSeparators;
    alert.alertView.padding = _settings.padding;
    alert.alertView.verticalOffset = _settings.verticalOffset;
    alert.alertView.opacity = _settings.opacity;
    alert.alertView.maxAllowedWidth = _settings.maxAllowedWidth;
    alert.alertView.cornerRadius = _settings.cornerRadius;
    alert.alertView.actionItemPadding = _settings.actionPadding;
    alert.alertView.actionItemMargin = _settings.actionMargin;
    alert.alertView.preferedMargin = _settings.preferedMargin;
    alert.alertView.contentInset = _settings.contentInset;
    alert.alertView.customViewInset = _settings.customViewInset;
    alert.alertView.titleInset = _settings.titleInset;
    
    [alert addAction:[AXAlertAction actionWithTitle:@"Cancel" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
        config.translucent = _settings.actionTranslucent;
        config.translucentStyle = _settings.actionTranslucentStyle;
        
        config.preferedHeight = 44.0;
        config.backgroundColor = [UIColor whiteColor];
        config.font = [UIFont boldSystemFontOfSize:17];
        config.cornerRadius = .0;
        config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    }];
    [alert addAction:[AXAlertAction actionWithTitle:@"OK" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
        config.translucent = _settings.actionTranslucent;
        config.translucentStyle = _settings.actionTranslucentStyle;
        
        config.font = [UIFont systemFontOfSize:17];
        config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    }];
    return alert;
}

- (UIImage *)_resizedTouchImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(44.0, 44.0), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, 44.0);
    CGContextScaleCTM(context, 1.0, -1);
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextDrawImage(context, CGRectMake(0, 0, 44.0, 44.0), [UIImage imageNamed:@"touch"].CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}
@end
