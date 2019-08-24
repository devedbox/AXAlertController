//
//  TableViewController.m
//  AXAlertView
//
//  Created by devedbox on 2017/5/24.
//  Copyright © 2017年 devedbox. All rights reserved.
//

#import "TableViewController.h"
#import "AXAlertView.h"
#import "AXActionSheet.h"
#import "AXAlertController.h"

@interface TableViewController ()

@end

@implementation TableViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showNormal:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Some Title..." message:@"Some message..." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    for (int i = 0; i < 15; i++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            // textField.borderStyle = UITextBorderStyleRoundedRect;
            // textField.font = [UIFont boldSystemFontOfSize:21];
            textField.placeholder = @"Type text...";
        }];
    }
    [self presentViewController:alert animated:YES completion:^{
        
//        for (UIView *view in alert.view.subviews) {
//            for (UIView *_view in view.subviews) {
//                for (UIView *__view in _view.subviews) {
//                    for (UIView *___view in __view.subviews) {
//                        if ([___view isKindOfClass:UIVisualEffectView.class]) {
//                            ___view.hidden = YES;
//                        }
//                    }
//                }
//            }
//        }
    }];
    alert.modalPresentationStyle = UIModalPresentationPageSheet;
    return;
    AXAlertView *alertView = [[AXAlertView alloc] initWithFrame:self.navigationController.view.bounds];
    alertView.customViewInset = UIEdgeInsetsMake(5, 20, 10, 20);
    alertView.padding = 0;
    alertView.cornerRadius = 10.0;
    alertView.actionItemMargin = 0;
    alertView.actionItemPadding = 0;
    alertView.titleLabel.numberOfLines = 0;
    alertView.hidesOnTouch = YES;
    alertView.preferredMargin = UIEdgeInsetsMake(52, 52, 52, 52);
    alertView.title = @"兑换申请已受理";
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.text = @"您还有497个流量币可以兑换，继续兑换？";
    
    alertView.customView = label;
    
    alertView.titleLabel.font = [UIFont systemFontOfSize:14];
    
    alertView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    alertView.titleLabel.textColor = [UIColor blackColor];
    
    [alertView setActions:[AXAlertViewAction actionWithTitle:@"取消" image:nil handler:NULL],[AXAlertViewAction actionWithTitle:@"确认" image:nil handler:^(AXAlertViewAction * _Nonnull __weak action) {
        /*
         if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://www.baidu.com"]]) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
         }
         */
    }],nil];
    // alertView.showsSeparators = NO;
    // alertView.translucent = NO;
    
    AXAlertViewActionConfiguration *cancelConfig = [AXAlertViewActionConfiguration new];
    cancelConfig.backgroundColor = [UIColor whiteColor];
    cancelConfig.heightForLayout = 44;
    cancelConfig.cornerRadius = .0;
    cancelConfig.tintColor = [UIColor blackColor];
    [alertView setActionConfiguration:cancelConfig forItemAtIndex:0];
    AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
    // confirmConfig.backgroundColor = [UIColor blackColor];
    confirmConfig.backgroundColor = [UIColor whiteColor];
    confirmConfig.heightForLayout = 44;
    confirmConfig.cornerRadius = .0;
    // confirmConfig.tintColor = [UIColor blackColor];
    confirmConfig.tintColor = [UIColor whiteColor];
    confirmConfig.translucentStyle = AXAlertViewTranslucentDark;
    [alertView setActionConfiguration:confirmConfig forItemAtIndex:1];
    [self.navigationController.view addSubview:alertView];
    [alertView show:YES];
}

- (IBAction)showNormalWithoutCustomView:(id)sender {
    AXAlertView *alertView = [[AXAlertView alloc] initWithFrame:self.navigationController.view.bounds];
    alertView.customViewInset = UIEdgeInsetsMake(5, 20, 10, 20);
    alertView.padding = 5;
    alertView.cornerRadius = 10.0;
    alertView.actionItemMargin = 0;
    alertView.actionItemPadding = 0;
    alertView.titleLabel.numberOfLines = 0;
    alertView.hidesOnTouch = YES;
    alertView.title = @"Some title content...";
    alertView.titleLabel.font = [UIFont systemFontOfSize:14];
    alertView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    alertView.titleLabel.textColor = [UIColor blackColor];
    
    [alertView setActions:[AXAlertViewAction actionWithTitle:@"取消" image:nil handler:NULL],[AXAlertViewAction actionWithTitle:@"确认" image:nil handler:NULL],nil];
    // alertView.showsSeparators = NO;
    // alertView.translucent = NO;
    
    AXAlertViewActionConfiguration *cancelConfig = [AXAlertViewActionConfiguration new];
    cancelConfig.backgroundColor = [UIColor whiteColor];
    cancelConfig.heightForLayout = 44;
    cancelConfig.cornerRadius = .0;
    cancelConfig.tintColor = [UIColor blackColor];
    [alertView setActionConfiguration:cancelConfig forItemAtIndex:0];
    AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
    confirmConfig.backgroundColor = [UIColor whiteColor];
    confirmConfig.heightForLayout = 44;
    confirmConfig.cornerRadius = .0;
    confirmConfig.tintColor = [UIColor blackColor];
    [alertView setActionConfiguration:confirmConfig forItemAtIndex:1];
    
    [alertView setPreferredMargin:UIEdgeInsetsMake(40, 40, 40, 40)];
    // [alertView setPreferedHeight:14];
    [alertView setActionItemMargin:0];
    [alertView setActionItemPadding:0];
    
    [self.navigationController.view addSubview:alertView];
    [alertView show:YES];
    
    [self _delayUpdateAlertView:alertView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {
            [self showNormal:cell];
        } break;
        case 1: {
            [self showController:cell];
        } break;
        case 2: {
            [self showNormalWithoutCustomView:cell];
        } break;
        case 3: {
            [self showMoreItems:cell];
        } break;
        case 4: {
            [self showSheet:cell];
        } break;
        default:
            break;
    }
}

- (void)showSheet:(id)sender {
    AXAlertController *alert = [AXAlertController alertControllerWithTitle:@"Some title..." message:@"Some message..." preferredStyle:AXAlertControllerStyleActionSheet];
    [alert addAction:[AXAlertAction actionWithTitle:@"取消" style:1 handler:NULL]];
    [alert addAction:[AXAlertAction actionWithTitle:@"确认" handler:NULL]];
    // for (int i = 0; i < 15; i++) {
        // [alert addAction:[AXAlertAction actionWithTitle:[NSString stringWithFormat:@"index%@", @(i)] handler:NULL]];
    // }
    alert.image = [UIImage imageNamed:@"Image"];
    [self presentViewController:alert animated:YES completion:NULL];
    [self _delayUpdateAlertView:alert.alertView];
}

- (void)showController:(id)sender {
    AXAlertController *alert = [AXAlertController alertControllerWithTitle:@"Some Title..." message:@"Some message..." preferredStyle:AXAlertControllerStyleAlert];
    // alert.image = [UIImage imageNamed:@"Image"];
    [alert addAction:[AXAlertAction actionWithTitle:@"Cancel" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
        config.heightForLayout = 44.0;
        config.backgroundColor = [UIColor whiteColor];
        config.font = [UIFont boldSystemFontOfSize:17];
        config.cornerRadius = .0;
        config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    }];
    for (int i = 0; i < 1; i++) {
        [alert addAction:[AXAlertAction actionWithTitle:@"OK" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
            config.font = [UIFont systemFontOfSize:17];
            config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
        }];
    }
    for (int i = 0; i < 1; i++) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Type text...";
        }];
    }
    [alert configureImageViewWithHandler:^(UIImageView * _Nonnull imageView) {
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [self resizedTouchImage];
    }];
    [self presentViewController:alert animated:YES completion:NULL];
    [self _delayUpdateAlertView:alert.alertView];
}

- (void)showMoreItems:(id)sender {
    AXAlertView *alertView = [[AXAlertView alloc] initWithFrame:self.navigationController.view.bounds];
    alertView.customViewInset = UIEdgeInsetsMake(20, 20, 10, 20);
    alertView.padding = 0;
    alertView.cornerRadius = 10.0;
    alertView.actionItemMargin = 0;
    alertView.actionItemPadding = 0;
    alertView.titleLabel.numberOfLines = 0;
    alertView.hidesOnTouch = YES;
    alertView.title = @"兑换申请已受理";
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.text = @"您还有497个流量币可以兑换，继续兑换？";
    
    alertView.customView = label;
    
    // alertView.showsSeparators = NO;
    // alertView.translucent = NO;
    
    alertView.titleLabel.font = [UIFont systemFontOfSize:14];
    
    alertView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    alertView.titleLabel.textColor = [UIColor blackColor];
     
     for (int i = 0; i < 15; i++) {
     [alertView appendActions:[AXAlertViewAction actionWithTitle:[NSString stringWithFormat:@"index%@", @(i)] image:nil handler:NULL], nil];
     AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
     confirmConfig.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
     confirmConfig.heightForLayout = 50;
     confirmConfig.cornerRadius = .0;
     confirmConfig.tintColor = [UIColor whiteColor];
     // confirmConfig.tintColor = [UIColor blackColor];
     confirmConfig.translucent = YES;
     confirmConfig.translucentStyle = AXAlertViewTranslucentDark;
     // confirmConfig.translucentStyle = AXAlertViewTranslucentLight;
     [alertView setActionConfiguration:confirmConfig forItemAtIndex:i];
     }
    [self.navigationController.view addSubview:alertView];
    [alertView show:YES];
    
    [self _delayUpdateAlertView:alertView];
}

- (void)_delayUpdateAlertView:(AXAlertView *)alertView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // alertView.titleColor = [UIColor redColor];
        // alertView.titleFont = [UIFont systemFontOfSize:12];
        // alertView.translucent = NO;
        // alertView.translucentStyle = AXAlertViewTranslucentDark;
        // alertView.showsSeparators = NO;
        // alertView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
        // alertView.customViewInset = UIEdgeInsetsMake(50, 50, 50, 50);
        // alertView.titleInset = UIEdgeInsetsMake(50, 50, 50, 50);
        // alertView.padding = 50;
        // alertView.actionItemPadding = 20;
        // alertView.actionItemMargin = 20;
        // alertView.horizontalLimits = 20;
        // alertView.opacity
        // alertView.
        // alertView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image"]];
        // alertView.customView = nil;
        // alertView.verticalOffset = 100;
    });
}

- (UIImage *)resizedTouchImage {
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
