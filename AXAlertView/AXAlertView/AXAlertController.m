//
//  AXAlertController.m
//  AXAlertView
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

#import "AXAlertController.h"
#import "AXAlertView.h"

#ifndef AXAlertViewHooks
#define AXAlertViewHooks(_CustomView) @interface _CustomView : AXAlertView @end @implementation _CustomView @end
#endif

AXAlertViewHooks(_AXAlertControllerContentView)

@interface AXAlertController ()
/// Content alert view.
@property(strong, nonatomic) _AXAlertControllerContentView *alertContentView;
@end

@implementation AXAlertController
#pragma mark - Life cycle.
- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    super.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    super.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

#pragma mark - Overrides.
- (void)loadView {
    [super loadView];
    // [self.view addSubview:self.alertContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"Dismiss" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _alertContentView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.alertContentView showInView:self.view animated:YES];
}

- (void)_dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setModalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle {
    [super setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
}

- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    [super setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

#pragma mark - Getters.
- (AXAlertView *)alertView { return _alertContentView; }

- (_AXAlertControllerContentView *)alertContentView {
    if (_alertContentView) return  _alertContentView;
    _alertContentView = [[_AXAlertControllerContentView alloc] init];
    // _alertContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _alertContentView.customViewInset = UIEdgeInsetsMake(5, 20, 10, 20);
    _alertContentView.padding = 0;
    _alertContentView.cornerRadius = 10.0;
    _alertContentView.actionItemMargin = 0;
    _alertContentView.actionItemPadding = 0;
    _alertContentView.titleLabel.numberOfLines = 0;
    _alertContentView.hidesOnTouch = YES;
    _alertContentView.title = @"兑换申请已受理";
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.text = @"您还有497个流量币可以兑换，继续兑换？";
    
    _alertContentView.customView = label;
    
    _alertContentView.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _alertContentView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _alertContentView.titleLabel.textColor = [UIColor blackColor];
    
    [_alertContentView setActions:[AXAlertViewAction actionWithTitle:@"取消" image:nil handler:NULL],[AXAlertViewAction actionWithTitle:@"确认" image:nil handler:^(AXAlertViewAction * _Nonnull __weak action) {
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
    cancelConfig.preferedHeight = 44;
    cancelConfig.cornerRadius = .0;
    cancelConfig.tintColor = [UIColor blackColor];
    [_alertContentView setActionConfiguration:cancelConfig forItemAtIndex:0];
    AXAlertViewActionConfiguration *confirmConfig = [AXAlertViewActionConfiguration new];
    // confirmConfig.backgroundColor = [UIColor blackColor];
    confirmConfig.backgroundColor = [UIColor whiteColor];
    confirmConfig.preferedHeight = 44;
    confirmConfig.cornerRadius = .0;
    // confirmConfig.tintColor = [UIColor blackColor];
    confirmConfig.tintColor = [UIColor whiteColor];
    confirmConfig.translucentStyle = AXAlertViewTranslucentDark;
    [_alertContentView setActionConfiguration:confirmConfig forItemAtIndex:1];
    
    return _alertContentView;
}
@end
