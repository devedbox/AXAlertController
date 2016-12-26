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
    [showButton setTintColor:[UIColor blackColor]];
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
    self.view.backgroundColorTo([UIColor orangeColor]).duration(0.25).animate();
    // Do any additional setup after loading the view, typically from a nib.
    _alertView = [[AXAlertView alloc] initWithFrame:self.view.bounds];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.text = @"到你的骄傲带哦带爱上电脑我回到id宝id赛欧作曲 : G.E.M.作词 : G.E.M. 阳光下的泡沫 是彩色的 就像被骗的我 是幸福的 追究什么对错 你的谎言 基于你还爱我 美丽的泡沫 虽然一刹花火 你所有承诺 虽然都太脆弱 但爱像泡沫 如果能够看破 有什么难过 早该知道泡沫 一触就破 就像已伤的心 不胜折磨 也不是谁的错 谎言再多 基于你还爱我 美丽的泡沫 虽然一刹花火 你所有承诺 虽然都太脆弱 爱本是泡沫 如果能够看破 有什么难过 再美的花朵 盛开过就凋落 再亮眼的星 一闪过就坠落 爱本是泡沫 如果能够看破 有什么难过 为什么难过 有什么难过 为什么难过 全都是泡沫 只一刹的花火 你所有承诺 全部都太脆弱 而你的轮廓 怪我没有看破 才如此难过 相爱的把握 要如何再搜索 相拥着寂寞 难道就不寂寞 爱本是泡沫 怪我没有看破 才如此难过 在雨下的泡沫 一触就破 当初炽热的心 早已沉没 说什么你爱我 如果骗我 我宁愿你沉默";
    textLabel.numberOfLines = 0;
    _alertView.customView = textLabel;
    [_alertView setActions:[AXAlertViewAction actionWithTitle:@"确定" handler:^(AXAlertViewAction *action) {
        [_alertView showInView:self.view animated:YES];
    }],[AXAlertViewAction actionWithTitle:@"取消" handler:NULL],nil];
    _alertView.horizontalLimits = 1;
    _alertView.preferedHeight = 200;
    _alertView.title = @"测试";
    _alertView.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertView:(UIButton *)sender {
    /*
    [_alertView showInView:self.view animated:YES];
     */
    // Do any additional setup after loading the view, typically from a nib.
    AXAlertView *alertView = [[AXAlertView alloc] initWithFrame:self.view.bounds];
    alertView.titleInset = UIEdgeInsetsMake(35, 0, 35, 0);
    alertView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30);
    alertView.padding = 0;
    alertView.cornerRadius = .0;
    alertView.actionItemMargin = 0;
    alertView.actionItemPadding = 0;
    alertView.titleLabel.numberOfLines = 0;
    [alertView setActions:[AXAlertViewAction actionWithTitle:@"" image:[UIImage imageNamed:@"cancel"] handler:NULL],[AXAlertViewAction actionWithTitle:@"" image:[UIImage imageNamed:@"confirm"] handler:NULL],nil];
    alertView.title = @"告知当前状态，信息和解决方法，如果文字换行的情况";
    alertView.titleLabel.font = [UIFont systemFontOfSize:14];
    alertView.titleLabel.textColor = [UIColor blackColor];
    alertView.translucent = NO;
    alertView.backgroundColor = [UIColor whiteColor];
    AXAlertViewActionConfiguration *cancelConfig = [AXAlertViewActionConfiguration new];
    cancelConfig.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.00];
    cancelConfig.preferedHeight = 50;
    cancelConfig.cornerRadius = .0;
    [alertView setActionConfiguration:cancelConfig forItemAtIndex:0];
    AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
    confirmConfig.backgroundColor = [UIColor blackColor];
    confirmConfig.preferedHeight = 50;
    cancelConfig.cornerRadius = .0;
    [alertView setActionConfiguration:confirmConfig forItemAtIndex:1];
    [alertView show:YES];
}
@end
