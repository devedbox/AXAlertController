//
//  ViewController.m
//  AXAlertView
//
//  Created by ai on 16/4/5.
//  Copyright © 2016年 devedbox. All rights reserved.
//

#import "ViewController.h"
#import "AXAlertView.h"
#import <AXAnimationChain/UIView+AnimationChain.h>

#undef AXAlertViewUsingAutolayout
#define AXAlertViewUsingAutolayout 0

@interface ViewController ()
/// Alert view.
@property(strong, nonatomic) AXAlertView *alertView;
/// Show button.
@property(weak, nonatomic) UIButton *showButton;
@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    showButton.translatesAutoresizingMaskIntoConstraints = NO;
    [showButton setTitle:@"show" forState:UIControlStateNormal];
    [showButton setBackgroundColor:[UIColor clearColor]];
    [showButton setAdjustsImageWhenHighlighted:YES];
    [showButton setAdjustsImageWhenDisabled:YES];
    [showButton setTintColor:[UIColor whiteColor]];
    [showButton.layer setCornerRadius:4];
    [showButton.layer setMasksToBounds:YES];
    [showButton addTarget:self action:@selector(showAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    _showButton = showButton;

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[showButton]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(showButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[showButton(==56)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(showButton)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view, typically from a nib.
    _alertView = [[AXAlertView alloc] initWithFrame:self.view.bounds];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.text = @"到你的骄傲带哦带爱上电脑我回到id宝id赛欧作曲 : G.E.M.作词 : G.E.M. 阳光下的泡沫 是彩色的 就像被骗的我 是幸福的 追究什么对错 你的谎言 基于你还爱我 美丽的泡沫 虽然一刹花火 你所有承诺 虽然都太脆弱 但爱像泡沫 如果能够看破 有什么难过 早该知道泡沫 一触就破 就像已伤的心 不胜折磨 也不是谁的错 谎言再多";
    textLabel.numberOfLines = 0;
    _alertView.customView = textLabel;
    [_alertView setActions:[AXAlertViewAction actionWithTitle:@"确定" handler:^(AXAlertViewAction *action) {
        [_alertView showInView:self.view animated:YES];
    }],[AXAlertViewAction actionWithTitle:@"取消" handler:NULL],nil];
    _alertView.horizontalLimits = 2;
    _alertView.preferedHeight = 200;
    _alertView.title = @"测试";
    _alertView.translucent = YES;
    _alertView.hidesOnTouch = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertView:(UIButton *)sender {
    
//    [_alertView showInView:self.view animated:YES];
//    return;
    // Do any additional setup after loading the view, typically from a nib.
    
    AXAlertView *alertView = [[AXAlertView alloc] initWithFrame:self.view.bounds];
//    alertView.titleInset = UIEdgeInsetsMake(35, 30, 35, 30);
    alertView.customViewInset = UIEdgeInsetsMake(5, 20, 10, 20);
    alertView.padding = 0;
    alertView.cornerRadius = 10.0;
    alertView.actionItemMargin = 0;
    alertView.actionItemPadding = 0;
    alertView.titleLabel.numberOfLines = 0;
    alertView.hidesOnTouch = YES;
//    alertView.title = @"告知当前状态，信息和解决方法，如果文字换行的情况";
    alertView.title = @"兑换申请已受理";
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.text = @"您还有497个流量币可以兑换，继续兑换？";
    
    alertView.customView = label;
    
//    alertView.titleLabel.font = [UIFont systemFontOfSize:14];
    
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
    cancelConfig.preferedHeight = 50;
    cancelConfig.cornerRadius = .0;
    cancelConfig.tintColor = [UIColor blackColor];
    [alertView setActionConfiguration:cancelConfig forItemAtIndex:0];
    AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
    confirmConfig.backgroundColor = [UIColor blackColor];
    confirmConfig.preferedHeight = 50;
    confirmConfig.cornerRadius = .0;
    confirmConfig.tintColor = [UIColor whiteColor];
    confirmConfig.translucentStyle = AXAlertViewTranslucentDark;
    [alertView setActionConfiguration:confirmConfig forItemAtIndex:1];
    [alertView showInView:self.view animated:YES];
    
    /*
    for (int i = 0; i < 10; i++) {
        [alertView appendActions:[AXAlertViewAction actionWithTitle:[NSString stringWithFormat:@"index%@", @(i)] image:nil handler:NULL], nil];
        AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
        confirmConfig.backgroundColor = [UIColor blackColor];
        confirmConfig.preferedHeight = 50;
        confirmConfig.cornerRadius = .0;
        confirmConfig.tintColor = [UIColor blackColor];
//        confirmConfig.translucent = NO;
//        confirmConfig.translucentStyle = AXAlertViewTranslucentDark;
        confirmConfig.translucentStyle = AXAlertViewTranslucentLight;
        [alertView setActionConfiguration:confirmConfig forItemAtIndex:i];
    }
    [alertView show:YES];
    
    */
    /*
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Heheda" message:@"Hahaha" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    [self presentViewController:alert animated:YES completion:NULL];
     */
}
@end
