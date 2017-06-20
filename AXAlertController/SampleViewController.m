//
//  SampleViewController.m
//  AXAlertController
//
//  Created by devedbox on 2017/6/20.
//  Copyright © 2017年 devedbox. All rights reserved.
//

#import "SampleViewController.h"
#import "AXAlertController.h"

@interface SampleViewController ()

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
        default:
            break;
    }
}

#pragma mark - Actions.
- (IBAction)showNormal:(id)sender {
    AXAlertController *alert = [AXAlertController alertControllerWithTitle:@"Some title..." message:@"Some message..." preferredStyle:AXAlertControllerStyleAlert];
    [alert addAction:[AXAlertAction actionWithTitle:@"Cancel" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
        config.preferedHeight = 44.0;
        config.backgroundColor = [UIColor whiteColor];
        config.font = [UIFont boldSystemFontOfSize:17];
        config.cornerRadius = .0;
        config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    }];
    [alert addAction:[AXAlertAction actionWithTitle:@"OK" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
        config.font = [UIFont systemFontOfSize:17];
        config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    }];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (IBAction)showWithImage:(id)sender {
    AXAlertController *alert = [AXAlertController alertControllerWithTitle:@"Some title..." message:@"Some message..." preferredStyle:AXAlertControllerStyleAlert];
    [alert configureImageViewWithHandler:^(UIImageView * _Nonnull imageView) {
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [self _resizedTouchImage];
    }];
    [alert addAction:[AXAlertAction actionWithTitle:@"Cancel" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
        config.preferedHeight = 44.0;
        config.backgroundColor = [UIColor whiteColor];
        config.font = [UIFont boldSystemFontOfSize:17];
        config.cornerRadius = .0;
        config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    }];
    [alert addAction:[AXAlertAction actionWithTitle:@"OK" style:AXAlertActionStyleDefault handler:NULL] configurationHandler:^(AXAlertActionConfiguration * _Nonnull config) {
        config.font = [UIFont systemFontOfSize:17];
        config.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    }];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - Private.
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
