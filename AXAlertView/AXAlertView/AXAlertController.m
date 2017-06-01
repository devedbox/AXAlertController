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

#ifndef AXAlertViewHooks
#define AXAlertViewHooks(_CustomView) @interface _CustomView : AXAlertView @end @implementation _CustomView @end
#endif
#ifndef AXActionSheetHooks
#define AXActionSheetHooks(_CustomView) @interface _CustomView : AXActionSheet @end @implementation _CustomView @end
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

AXAlertViewHooks(_AXAlertControllerAlertContentView)
AXActionSheetHooks(_AXAlertControllerSheetContentView)
AXAlertCustomSuperViewHooks(_AXAlertExceptionView)
AXAlertCustomExceptionViewHooks(_AXAlertControllerView, _AXAlertExceptionView)

AXAlertControllerDelegateHooks(_AXAlertCustomSuperViewDelegate)
@interface AXAlertController () <AXAlertViewDelegate> {
    BOOL _isBeingPresented;
    BOOL _isViewDidAppear;
    BOOL _animated;
    
    BOOL _translucent;
    
    AXAlertControllerStyle _style;
    NSMutableArray<AXAlertAction *> *_actions;
}
/// Content view.
@property(readonly, nonatomic) AXAlertView *contentView;
/// Content alert view.
@property(strong, nonatomic) _AXAlertControllerAlertContentView *alertContentView;
/// Content action sheet view.
@property(strong, nonatomic) _AXAlertControllerSheetContentView *actionSheetContentView;
/// Message label.
@property(strong, nonatomic) UILabel *messageLabel;

@property(readonly, nonatomic) _AXAlertControllerView *underlyingView;

/// Set the style of the alert controller.
- (void)_setStyle:(uint64_t)arg;
@end

@interface AXAlertAction () {
    // Handler block of action.
    AXAlertActionHandler _handler;
    
    NSString *__title;
    uint64_t __style;
    UIImage *__image;
}
@property(readonly, nonatomic) AXAlertViewAction *alertViewAction;
@property(readonly, nonatomic) AXActionSheetAction *actionSheetAction;
@end

@implementation AXAlertAction
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image style:(AXAlertActionStyle)style handler:(AXAlertActionHandler)handler {
    if (self = [super init]) {
        _handler = [handler copy];
        __title = [title copy];
        __style = style;
        __image = image;
    }
    return self;
}

+ (instancetype)actionWithTitle:(NSString *)title handler:(AXAlertActionHandler)handler {
    return [self actionWithTitle:title style:AXAlertActionStyleDefault handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title style:(AXAlertActionStyle)style handler:(AXAlertActionHandler)handler {
    return [self actionWithTitle:title image:nil style:style handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image style:(AXAlertActionStyle)style handler:(AXAlertActionHandler)handler {
    return [[self alloc] initWithTitle:title image:image style:style handler:handler];
}

- (NSString *)title { return [__title copy]; }
- (AXAlertActionStyle)style { return __style; }

- (AXAlertViewAction *)alertViewAction {
    AXAlertViewAction *_a = [AXAlertViewAction actionWithTitle:[__title copy] image:__image handler:^(AXAlertViewAction * _Nonnull __weak action) {
        if (_handler != NULL) { __weak typeof(self) wself = self; _handler(wself); }
    }];
    _a.identifier = self.identifier;
    return _a;
}

- (AXActionSheetAction *)actionSheetAction {
    AXActionSheetAction *_a = [AXActionSheetAction actionWithTitle:[__title copy] image:__image style:__style handler:^(AXAlertViewAction * _Nonnull __weak action) {
        if (_handler != NULL) { __weak typeof(self) wself = self; _handler(wself); }
    }];
    _a.identifier = self.identifier;
    return _a;
}
@end @implementation AXAlertActionConfiguration @end

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

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(AXAlertControllerStyle)preferredStyle {
    AXAlertController *alert = [[self alloc] init];
    [alert _setStyle:preferredStyle];
    alert.contentView.title = title;
    alert.contentView.customView = alert.messageLabel;
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
        [self _addContentViewToContainer];
        if (_style == AXAlertControllerStyleActionSheet) {
            [self.contentView show:_animated];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isBeingPresented = [self isBeingPresented];
    _animated = animated;
    
    if (!_isViewDidAppear && _style == AXAlertControllerStyleAlert) [self.contentView show:animated];
}

- (void)viewWillMoveToSuperview:(UIView *)newSuperView {}
- (void)viewDidMoveToSuperview {}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _isViewDidAppear = YES;
    // _alertContentView.translucent = YES;
    if (self.contentView.superview != self.view) {
        [self.view addSubview:self.contentView];
    }
}

#pragma mark - Public.
- (void)addAction:(AXAlertAction *)action {
    [self addAction:action configuration:nil];
}

- (void)addAction:(AXAlertAction *)action configuration:(AXAlertActionConfiguration *)config {
    if (!_actions) _actions = [NSMutableArray array];
    [_actions addObject:action];
    
    if (config) [self.contentView setActionConfiguration:config forKey:action.identifier.length?action.identifier:[NSString stringWithFormat:@"%@", @(_actions.count-1)]];
    
    if (_style == AXAlertControllerStyleActionSheet) {
        AXActionSheetAction *_action = action.actionSheetAction;
        if (action.style == AXAlertActionStyleCancel) {
            _action.identifier = @"__cancel_ac";
            AXAlertViewActionConfiguration *cancel = [AXAlertViewActionConfiguration new];
            cancel.backgroundColor = [UIColor whiteColor];
            cancel.preferedHeight = 44;
            cancel.cornerRadius = .0;
            cancel.separatorHeight = .0;
            cancel.tintColor = [UIColor redColor];
            [self.contentView setActionConfiguration:cancel forKey:_action.identifier];
        }
        [self.contentView appendActions:_action, nil];
    } else {
        AXAlertViewAction *_action = action.alertViewAction;
        [self.contentView appendActions:_action, nil];
    }
}

#pragma mark - Getters.
- (AXAlertView *)contentView { return (_style==AXAlertControllerStyleActionSheet?self.actionSheetContentView:self.alertContentView); }
- (NSArray<AXAlertAction *> *)actions { return [_actions copy]; }
- (NSString *)title { return _alertContentView.title; }
- (NSString *)message { return _messageLabel.text; }
- (AXAlertControllerStyle)preferredStyle { return _style; }
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

- (_AXAlertControllerAlertContentView *)alertContentView {
    if (_alertContentView) return  _alertContentView;
    _alertContentView = [[_AXAlertControllerAlertContentView alloc] initWithFrame:self.view.bounds];
    [_alertContentView setBackgroundColor:[UIColor whiteColor]];
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
    _alertContentView.preferedMargin = UIEdgeInsetsMake(52, 52, 52, 52);
    _alertContentView.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _alertContentView.titleLabel.textColor = [UIColor blackColor];
    AXAlertViewActionConfiguration *config = [AXAlertViewActionConfiguration new];
    config.backgroundColor = [UIColor whiteColor];
    config.preferedHeight = 44;
    config.cornerRadius = .0;
    config.tintColor = [UIColor blackColor];
    config.font = [UIFont systemFontOfSize:16];
    [_alertContentView setActionConfiguration:config];
    
    return _alertContentView;
}

- (_AXAlertControllerSheetContentView *)actionSheetContentView {
    if (_actionSheetContentView) return _actionSheetContentView;
    _actionSheetContentView = [[_AXAlertControllerSheetContentView alloc] initWithFrame:self.view.bounds];
    [_actionSheetContentView setBackgroundColor:[UIColor whiteColor]];
    [_actionSheetContentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _actionSheetContentView.opacity = 0.0;
    _actionSheetContentView.titleInset = UIEdgeInsetsMake(20, 16, 0, 16);
    _actionSheetContentView.delegate = self;
    _actionSheetContentView.customViewInset = UIEdgeInsetsMake(5, 15, 20, 15);
    _actionSheetContentView.padding = 0;
    _actionSheetContentView.hidesOnTouch = YES;
    _actionSheetContentView.cornerRadius = 12.0;
    _actionSheetContentView.actionItemMargin = 0;
    _actionSheetContentView.actionItemPadding = 0;
    _actionSheetContentView.titleLabel.numberOfLines = 0;
    _actionSheetContentView.preferedMargin = UIEdgeInsetsMake(52, 52, 52, 52);
    _actionSheetContentView.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _actionSheetContentView.titleLabel.textColor = [UIColor blackColor];
    AXAlertViewActionConfiguration *config = [AXAlertViewActionConfiguration new];
    config.backgroundColor = [UIColor whiteColor];
    config.preferedHeight = 44;
    config.cornerRadius = .0;
    config.tintColor = [UIColor blackColor];
    [_actionSheetContentView setActionConfiguration:config];
    
    return _actionSheetContentView;
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
- (void)alertViewWillShow:(AXAlertView *)alertView {
    if (_style == AXAlertControllerStyleActionSheet) {
        UIView *view = [_actionSheetContentView valueForKeyPath:@"animatingView"];
        [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:self.underlyingView.opacity]];
        [self.underlyingView addSubview:view];
    } else {
        _translucent = self.contentView.translucent;
        self.contentView.translucent = NO;
    }
}

- (void)alertViewDidShow:(AXAlertView *)alertView {
    if (_style == AXAlertControllerStyleAlert) {
        self.contentView.translucent = _translucent;
    }
}

- (void)alertViewWillHide:(AXAlertView *)alertView {
    if (_style == AXAlertControllerStyleActionSheet) {
        // [self _addContentViewToContainer];
        UIView *transitionView = [_actionSheetContentView valueForKeyPath:@"transitionView"];
        UIView *containerView = /*self.view.superview ?: self.view*/self.view.window;
        [containerView addSubview:transitionView];
    } else {
        _translucent = self.contentView.translucent;
        self.contentView.translucent = NO;
    }
    [self _dismiss:alertView];
}

- (void)alertViewDidHide:(AXAlertView *)alertView {
    if (_style == AXAlertControllerStyleAlert) {
        self.contentView.translucent = _translucent;
    }
}

#pragma mark - Private.
- (void)_dismiss:(id)sender {
    if (_isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)_setStyle:(uint64_t)arg { _style = arg; }

- (void)_addContentViewToContainer {
    UIView *containerView = self.view.superview ?: self.view;
    if (_style == AXAlertControllerStyleAlert) {
        containerView = self.view;
    }
    [containerView addSubview:self.contentView];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    [self.underlyingView setExceptionFrame:[[self.contentView valueForKeyPath:@"containerView.frame"] CGRectValue]];
    [self.underlyingView setCornerRadius:self.contentView.cornerRadius];
    [self.underlyingView setNeedsDisplay];
}
@end
