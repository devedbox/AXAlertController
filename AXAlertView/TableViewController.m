//
//  TableViewController.m
//  AXAlertView
//
//  Created by devedbox on 2017/5/24.
//  Copyright © 2017年 devedbox. All rights reserved.
//

#import "TableViewController.h"
#import "AXAlertView.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = backgroundView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showNormal:(id)sender {
    AXAlertView *alertView = [[AXAlertView alloc] initWithFrame:self.view.bounds];
    alertView.customViewInset = UIEdgeInsetsMake(5, 20, 10, 20);
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
    
    AXAlertViewActionConfiguration *cancelConfig = [AXAlertViewActionConfiguration new];
    cancelConfig.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.00];
    cancelConfig.preferedHeight = 44;
    cancelConfig.cornerRadius = .0;
    cancelConfig.tintColor = [UIColor blackColor];
    [alertView setActionConfiguration:cancelConfig forItemAtIndex:0];
    AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
    confirmConfig.backgroundColor = [UIColor blackColor];
    confirmConfig.preferedHeight = 44;
    confirmConfig.cornerRadius = .0;
    // confirmConfig.tintColor = [UIColor blackColor];
    confirmConfig.tintColor = [UIColor whiteColor];
    confirmConfig.translucentStyle = AXAlertViewTranslucentDark;
    [alertView setActionConfiguration:confirmConfig forItemAtIndex:1];
    [alertView showInView:self.view animated:YES];
}

- (IBAction)showNormalWithoutCustomView:(id)sender {
    AXAlertView *alertView = [[AXAlertView alloc] initWithFrame:self.view.bounds];
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
    
    AXAlertViewActionConfiguration *cancelConfig = [AXAlertViewActionConfiguration new];
    cancelConfig.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.00];
    cancelConfig.preferedHeight = 44;
    cancelConfig.cornerRadius = .0;
    cancelConfig.tintColor = [UIColor blackColor];
    [alertView setActionConfiguration:cancelConfig forItemAtIndex:0];
    AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
    confirmConfig.backgroundColor = [UIColor blackColor];
    confirmConfig.preferedHeight = 44;
    confirmConfig.cornerRadius = .0;
    confirmConfig.tintColor = [UIColor blackColor];
    // confirmConfig.tintColor = [UIColor whiteColor];
    // confirmConfig.translucentStyle = AXAlertViewTranslucentDark;
    [alertView setActionConfiguration:confirmConfig forItemAtIndex:1];
    [alertView showInView:self.view animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {
            [self showNormal:cell];
        } break;
        case 1: {
            [self showNormalWithoutCustomView:cell];
        } break;
        default:
            break;
    }
}
@end
