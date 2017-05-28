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
#ifndef AXAlertCustomSuperViewHooks
#define AXAlertCustomSuperViewHooks(_CustomView) @protocol _AXAlertCustomSuperViewDelegate <NSObject>\
- (void)viewWillMoveToSuperview:(UIView *)newSuperView;\
- (void)viewDidMoveToSuperview;\
@end @interface _CustomView : UIView\
@property(weak, nonatomic) id<_AXAlertCustomSuperViewDelegate> delegate;\
@end @implementation _CustomView\
- (void)willMoveToSuperview:(UIView *)newSuperview { [super willMoveToSuperview:newSuperview]; [_delegate viewWillMoveToSuperview:newSuperview]; }\
- (void)didMoveToSuperview { [super didMoveToSuperview]; [_delegate viewDidMoveToSuperview]; }\
@end
#endif
#ifndef AXAlertCustomExceptionViewHooks
#define AXAlertCustomExceptionViewHooks(_ExceptionView, View) @interface _ExceptionView : View@property(assign, nonatomic) CGRect exceptionFrame;@property(assign, nonatomic) CGFloat cornerRadius;@property(assign, nonatomic) CGFloat opacity;@end@implementation _ExceptionView - (void)drawRect:(CGRect)rect {[super drawRect:rect];CGContextRef context = UIGraphicsGetCurrentContext();CGPathRef outterPath = CGPathCreateWithRect(self.frame, nil);CGContextAddPath(context, outterPath);CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:_opacity].CGColor);CGContextFillPath(context);CGPathRelease(outterPath);CGRect rectOfContainerView =_exceptionFrame;if (CGRectGetWidth(rectOfContainerView) < _cornerRadius*2 || CGRectGetHeight(rectOfContainerView) < _cornerRadius*2) return;CGPathRef innerPath = CGPathCreateWithRoundedRect(rectOfContainerView, _cornerRadius, _cornerRadius, nil);CGContextAddPath(context, innerPath);CGContextSetBlendMode(context, kCGBlendModeClear);CGContextFillPath(context);CGPathRelease(innerPath);}@end
#endif
#ifndef AXAlertControllerDelegateHooks
#define AXAlertControllerDelegateHooks(_Delegate) @interface AXAlertController (_Delegate) <_Delegate> @end
#endif

AXAlertViewHooks(_AXAlertControllerContentView)
AXAlertCustomSuperViewHooks(_AXAlertExceptionView)
AXAlertCustomExceptionViewHooks(_AXAlertControllerView, _AXAlertExceptionView)

AXAlertControllerDelegateHooks(_AXAlertCustomSuperViewDelegate)
@interface AXAlertController () <AXAlertViewDelegate> {
    BOOL _isBeingPresented;
    BOOL _isViewDidAppear;
}
/// Content alert view.
@property(strong, nonatomic) _AXAlertControllerContentView *alertContentView;
/// Message label.
@property(strong, nonatomic) UILabel *messageLabel;

@property(readonly, nonatomic) _AXAlertControllerView *underlyingView;
@end

@implementation AXAlertController @dynamic title;
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

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    AXAlertController *alert = [[self alloc] init];
    alert.alertContentView.title = title;
    alert.alertContentView.customView = alert.messageLabel;
    alert.messageLabel.text = message;
    return alert;
}

#pragma mark - Overrides.
- (void)loadView {
    [super loadView];
    _AXAlertControllerView *view = [[_AXAlertControllerView alloc] initWithFrame:self.view.bounds];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [view setDelegate:self];
    [view setOpacity:0.4];
    self.view = view;
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!_isViewDidAppear) {
        UIView *containerView = self.view.superview ?: self.view;
        [containerView addSubview:self.alertContentView];
        [_alertContentView setNeedsLayout];
        [_alertContentView layoutIfNeeded];
        [self.underlyingView setExceptionFrame:[[_alertContentView valueForKeyPath:@"containerView.frame"] CGRectValue]];
        [self.underlyingView setCornerRadius:_alertContentView.cornerRadius];
        [self.underlyingView setNeedsDisplay];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isBeingPresented = [self isBeingPresented];
    
    if (!_isViewDidAppear) [self.alertContentView show:animated];
}

- (void)viewWillMoveToSuperview:(UIView *)newSuperView {}
- (void)viewDidMoveToSuperview {}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _isViewDidAppear = YES;
    // _alertContentView.translucent = YES;
    if (_alertContentView.superview != self.view) {
        [self.view addSubview:_alertContentView];
    }
}

#pragma mark - Public.
- (void)addAction:(AXAlertAction *)action {
    AXAlertViewActionConfiguration *config = [AXAlertViewActionConfiguration new];
    config.backgroundColor = [UIColor whiteColor];
    config.preferedHeight = 44;
    config.cornerRadius = .0;
    config.tintColor = [UIColor blackColor];
    config.font = [UIFont systemFontOfSize:16];
    [_alertContentView setActionConfiguration:config];
    [_alertContentView appendActions:action, nil];
}

#pragma mark - Getters.
- (NSArray<AXAlertAction *> *)actions { return _alertContentView.actionItems; }
- (NSString *)title { return _alertContentView.title; }
- (NSString *)message { return _messageLabel.text; }
- (AXAlertView *)alertView { return _alertContentView; }
- (_AXAlertControllerView *)underlyingView { return (_AXAlertControllerView *)self.view; }

- (UILabel *)messageLabel {
    if (_messageLabel) return _messageLabel;
    _messageLabel = [UILabel new];
    _messageLabel.font = [UIFont systemFontOfSize:13];
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    return _messageLabel;
}

- (_AXAlertControllerContentView *)alertContentView {
    if (_alertContentView) return  _alertContentView;
    _alertContentView = [[_AXAlertControllerContentView alloc] initWithFrame:self.view.bounds];
    [_alertContentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _alertContentView.opacity = 0.0;
    _alertContentView.titleInset = UIEdgeInsetsMake(20, 16, 0, 16);
    _alertContentView.delegate = self;
    _alertContentView.customViewInset = UIEdgeInsetsMake(5, 15, 20, 15);
    _alertContentView.padding = 0;
    _alertContentView.cornerRadius = 12.0;
    _alertContentView.actionItemMargin = 0;
    _alertContentView.actionItemPadding = 0;
    _alertContentView.titleLabel.numberOfLines = 0;
    _alertContentView.preferedMargin = 52;
    _alertContentView.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _alertContentView.titleLabel.textColor = [UIColor blackColor];
    
    return _alertContentView;
}

#pragma mark - Setters.
- (void)setTitle:(NSString *)title {
    [_alertContentView setTitle:title];
}

- (void)setMessage:(NSString *)message {
    [_messageLabel setText:message];
}

- (void)setModalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle {
    [super setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
}

- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    [super setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

#pragma mark - AXAlertViewDelegate.
- (void)alertViewWillHide:(AXAlertView *)alertView {
    [self _dismiss:alertView];
}

#pragma mark - Private.
- (void)_dismiss:(id)sender {
    if (_isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
@end
