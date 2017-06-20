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
}

#pragma mark - Actions.
- (IBAction)showNormal:(id)sender {
    AXAlertController *alert = [AXAlertController alertControllerWithTitle:@"Some title..." message:@"Some message..." preferredStyle:UIAlertControllerStyleAlert];
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
@end
