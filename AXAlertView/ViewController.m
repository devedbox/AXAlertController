//
//  ViewController.m
//  AXAlertView
//
//  Created by ai on 16/4/5.
//  Copyright © 2016年 devedbox. All rights reserved.
//

#import "ViewController.h"
#import "AXAlertView.h"

@interface ViewController ()
/// Alert view.
@property(strong, nonatomic) AXAlertView *alertView;
@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    showButton.translatesAutoresizingMaskIntoConstraints = NO;
    [showButton setTitle:@"show" forState:UIControlStateNormal];
    [showButton setBackgroundColor:[UIColor blueColor]];
    [showButton setTintColor:[UIColor whiteColor]];
    [showButton.layer setCornerRadius:4];
    [showButton.layer setMasksToBounds:YES];
    [showButton addTarget:self action:@selector(showAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[showButton]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(showButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[showButton(==56)]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(showButton)]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _alertView = [[AXAlertView alloc] initWithFrame:self.view.bounds];
    
    [_alertView setActions:[AXAlertViewAction actionWithTitle:@"确定" handler:^(AXAlertViewAction *action) {
        [_alertView showInView:self.view animated:YES];
    }],[AXAlertViewAction actionWithTitle:@"取消" handler:^(AXAlertViewAction *action) {
        [_alertView hideAnimated:YES];
    }],nil];
//    _alertView.horizontalLimits = 1;
    _alertView.preferedHeight = 500;
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
    [_alertView showInView:self.view animated:YES];
}
@end