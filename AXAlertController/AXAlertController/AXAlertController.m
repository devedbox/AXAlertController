//
//  AXAlertController.m
//  AXAlertController
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
#import "AXAlertConstant.h"

#ifndef AXAlertViewHooks
#define AXAlertViewHooks(_CustomView) @interface _CustomView : AXAlertView @end @implementation _CustomView @end
#endif
#ifndef AXActionSheetHooks
#define AXActionSheetHooks(_CustomView) @interface _CustomView : AXActionSheet @end @implementation _CustomView @end
#endif
#ifndef AXAlertCustomSuperViewHooks
#define AXAlertCustomSuperViewHooks(_CustomView, CocoaView) @protocol _AXAlertCustomSuperViewDelegate <NSObject>\
- (void)viewWillMoveToSuperview:(UIView *)newSuperView;\
- (void)viewDidMoveToSuperview;\
@end @interface _CustomView : CocoaView\
@property(weak, nonatomic) id<_AXAlertCustomSuperViewDelegate> delegate;\
@end @implementation _CustomView\
- (void)willMoveToSuperview:(UIView *)newSuperview { [super willMoveToSuperview:newSuperview]; [_delegate viewWillMoveToSuperview:newSuperview]; }\
- (void)didMoveToSuperview { [super didMoveToSuperview]; [_delegate viewDidMoveToSuperview]; }\
@end
#endif
#ifndef AXAlertCustomViewHooks2
#define AXAlertCustomViewHooks2(_CustomView, CocoaView) @interface _CustomView : CocoaView @end @implementation _CustomView @end
#endif
#ifndef AXAlertCustomExceptionViewHooks
#define AXAlertCustomExceptionViewHooks(_ExceptionView, View) @interface _ExceptionView : View@property(assign, nonatomic) CGRect exceptionFrame __deprecated_msg("Using dimming contet image instead.");@property(assign, nonatomic) CGFloat cornerRadius __deprecated_msg("Using dimming contet image instead.");@property(assign, nonatomic) CGFloat opacity __deprecated_msg("Using dimming contet image instead.");@end@implementation _ExceptionView - (void)drawRect:(CGRect)rect {[super drawRect:rect];CGContextRef context = UIGraphicsGetCurrentContext();CGPathRef outterPath = CGPathCreateWithRect(self.frame, nil);CGContextAddPath(context, outterPath);CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:_opacity].CGColor);CGContextFillPath(context);CGPathRelease(outterPath);CGRect rectOfContainerView =_exceptionFrame;if (CGRectGetWidth(rectOfContainerView) < _cornerRadius*2 || CGRectGetHeight(rectOfContainerView) < _cornerRadius*2) return;CGPathRef innerPath = CGPathCreateWithRoundedRect(rectOfContainerView, _cornerRadius, _cornerRadius, nil);CGContextAddPath(context, innerPath);CGContextSetBlendMode(context, kCGBlendModeClear);CGContextFillPath(context);CGPathRelease(innerPath);}@end
#endif
#ifndef AXAlertControllerDelegateHooks
#define AXAlertControllerDelegateHooks(_Delegate) @interface AXAlertController (_Delegate) <_Delegate> @end
#endif

AXAlertViewHooks(_AXAlertControllerAlertContentView)
AXActionSheetHooks(_AXAlertControllerSheetContentView)
AXAlertCustomSuperViewHooks(_AXAlertExceptionView, UIImageView)
AXAlertCustomExceptionViewHooks(_AXAlertControllerView, _AXAlertExceptionView)
AXAlertCustomViewHooks2(_AXAlertKeybboardAlignmentView, UIImageView)

AXAlertControllerDelegateHooks(_AXAlertCustomSuperViewDelegate)
@interface AXAlertView (Private)
- (BOOL)processing;// Access to `_processing`, Used inside the module.
- (void)_layoutSubviews;// Layout subviews.
+ (BOOL)usingAutolayout;
+ (UIImage *)_dimmingKnockoutImageOfExceptionRect:(CGRect)exceptionRect cornerRadius:(CGFloat)cornerRadius inRect:(CGRect)mainBounds opacity:(CGFloat)opacity;
@end

AXAlertCustomViewHooks2(_AXAlertTextfield, UITextField)
AXAlertCustomViewHooks2(_AXAlertContentBackgroundView, UIView)

@interface _AXAlertControllerContentView: UIView
/// Stack view for using autolayout.
@property(strong, nonatomic) UIStackView *stackView;
/// Content label.
@property(strong, nonatomic) UILabel *contentLabel;
/// Content image view.
@property(strong, nonatomic) UIImageView *imageView;
/// Image top margin. Defaults to 10.0.
@property(assign, nonatomic) CGFloat padding;
/// Text fields.
@property(copy, nonatomic) NSMutableArray<UITextField *> *textFields;
/// Overrides effect.
@property(strong, nonatomic) UIBlurEffect *overridesEffect;

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler;
- (void)disableVisualEffects;
- (void)enableVisualEffects;
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

- (id)copyWithZone:(NSZone *)zone {
    AXAlertAction *action = [[AXAlertAction allocWithZone:zone] init];
    action.identifier = _identifier;
    action->_handler = [_handler copy];
    action->__title = [__title copy];
    action->__image = __image;
    action->__style = __style;
    return action;
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

@implementation _AXAlertControllerContentView
#pragma mark - Life cycle.
- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    } return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    } return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    } return self;
}

- (void)initializer {
    _padding = 10.0;
    _overridesEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _textFields = [NSMutableArray array];
    
    if ([AXAlertView usingAutolayout]) {
        [self addSubview:self.stackView];
        [self _addContraintsOfStackViewToSelf];
        [_stackView addArrangedSubview:self.contentLabel];
        [_stackView addArrangedSubview:self.imageView];
    } else {
        [self addSubview:self.contentLabel];
        [self addSubview:self.imageView];
    }
}

- (void)dealloc {}
#pragma mark - Overrides.
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize susize = [super sizeThatFits:size];
    /// Calculate size of conte label.
    CGSize sizeOfContent = [_contentLabel.text boundingRectWithSize:CGSizeMake(susize.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentLabel.font} context:NULL].size;
    susize.height += ceil(sizeOfContent.height);
    // Add padding.
    susize.height += _padding;
    // Calculate size of image view.
    [_imageView sizeToFit];
    CGSize sizeOfImage = _imageView.image.size;
    if (_imageView.image.size.width > susize.width) {
        sizeOfImage.width = susize.width;
    }
    susize.height += sizeOfImage.height;
    
    if (_textFields.count > 0) {
        susize.height += _padding;
        
    }
    return susize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (![AXAlertView usingAutolayout]) {
        CGRect rect_label = _contentLabel.frame;
        CGRect rect_image = _imageView.frame;
        
        rect_label.size.width = CGRectGetWidth(self.bounds);
        rect_image.origin.y = CGRectGetMaxY(rect_label)+_padding;
        
        _contentLabel.frame = rect_label;
        _imageView.frame = rect_image;
    }
}

#pragma mark - Public.
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler {
    _AXAlertTextfield *textField = [_AXAlertTextfield new];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:13];
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UIView *_textBackgroundView = [_AXAlertContentBackgroundView new];
    [_textBackgroundView setBackgroundColor:[UIColor clearColor]];
    _textBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:_overridesEffect]];
    effectView.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *_masksView = [UIView new];
    [_masksView setBackgroundColor:[UIColor clearColor]];
    _masksView.translatesAutoresizingMaskIntoConstraints = NO;
    _masksView.layer.borderWidth = 0.5;
    _masksView.layer.borderColor = [UIColor whiteColor].CGColor;
    [effectView.contentView addSubview:_masksView];
    [effectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_masksView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_masksView)]];
    [effectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_masksView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_masksView)]];
    
    UIView *_backgroundColorView = [UIView new];
    _backgroundColorView.backgroundColor = [UIColor whiteColor];
    _backgroundColorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_textBackgroundView addSubview:effectView];
    [_textBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(effectView)]];
    [_textBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(effectView)]];
    
    [_textBackgroundView addSubview:_backgroundColorView];
    [_textBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0.5-[_backgroundColorView]-0.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundColorView)]];
    [_textBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.5-[_backgroundColorView]-0.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundColorView)]];
    
    [_textBackgroundView addSubview:textField];
    [_textBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[textField]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    [_textBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[textField]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textField)]];
    
    if (configurationHandler) {
        configurationHandler(textField);
    }
    if ([AXAlertView usingAutolayout]) {
        [_stackView addArrangedSubview:_textBackgroundView];
        [_textFields addObject:textField];
    } else {
        textField.translatesAutoresizingMaskIntoConstraints = YES;
    }
}

- (void)disableVisualEffects {
    for (UIView *view in self.stackView.arrangedSubviews) {
        if ([view isKindOfClass:[_AXAlertContentBackgroundView class]]) {
            view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
            view.layer.borderWidth = 0.5;
            for (UIView *effectView in view.subviews) {
                if ([effectView isKindOfClass:[UIVisualEffectView class]]) {
                    [effectView setHidden:YES];
                }
            }
        }
    }
}

- (void)enableVisualEffects {
    for (UIView *view in self.stackView.arrangedSubviews) {
        if ([view isKindOfClass:[_AXAlertContentBackgroundView class]]) {
            view.layer.borderColor = [UIColor clearColor].CGColor;
            view.layer.borderWidth = 0.0;
            for (UIView *effectView in view.subviews) {
                if ([effectView isKindOfClass:[UIVisualEffectView class]]) {
                    [effectView setHidden:NO];
                }
            }
        }
    }
}
#pragma mark - Getters.
- (UIStackView *)stackView {
    if (_stackView) return _stackView;
    _stackView = [UIStackView new];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.distribution = UIStackViewDistributionFill;
    _stackView.alignment = UIStackViewAlignmentFill;
    _stackView.spacing = _padding;
    return _stackView;
}

- (UILabel *)contentLabel {
    if (_contentLabel) return _contentLabel;
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.backgroundColor = [UIColor clearColor];
    if ([AXAlertView usingAutolayout]) {
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentLabel;
}

- (UIImageView *)imageView {
    if (_imageView) return _imageView;
    _imageView = [UIImageView new];
    _imageView.backgroundColor = [UIColor clearColor];
    return _imageView;
}

#pragma mark - Setters.
- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    if ([AXAlertView usingAutolayout]) {
        _stackView.spacing = _padding;
    }
}

#pragma mark - Private.
- (void)_addContraintsOfStackViewToSelf {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_stackView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stackView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView)]];
}
@end

@interface AXAlertController () <AXAlertViewDelegate> {
    BOOL _isBeingPresented;
    BOOL _isViewDidAppear;
    BOOL _animated;// Whether showing transition is animated or not.
    BOOL _isAlertShowsTranitionTriggered;// Whether the alert view has showed any once.
    BOOL _isAlertShowsTranitionFinished;
    
    BOOL _translucent;
    BOOL _shouldExceptArea  __deprecated_msg("Using dimming content image instead.");
    /// Indicator is the keyboard alignment view is in animating or not. YES when animation is in processing, otherwise NO.
    BOOL _processingKeyboardAlignmentViewTransition;
    
    float _opacity; // Defaults to 0.4.
    NSLayoutConstraint *__weak _heightOfKeyboardAlignment;
    
    AXAlertControllerStyle _style;
    NSMutableArray<AXAlertAction *> *_actions;
}
/// Underlying view.
@property(strong, nonatomic) _AXAlertControllerView *underlyingView;
/// Keyboard alignment view.
@property(strong, nonatomic) _AXAlertKeybboardAlignmentView *keyboardAlignmentView;
/// Content alert view.
@property(strong, nonatomic) _AXAlertControllerAlertContentView *alertContentView;
/// Content action sheet view.
@property(strong, nonatomic) _AXAlertControllerSheetContentView *actionSheetContentView;
/// Content view.
@property(strong, nonatomic) _AXAlertControllerContentView *contentView;

/// Set the style of the alert controller.
- (void)_setStyle:(uint64_t)arg;
/// Set should except area.
- (void)_setShouldExceptArea:(BOOL)arg  __deprecated_msg("Using dimming content image instead.");
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
    _opacity = 0.4;
    super.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    super.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // _shouldExceptArea = YES;
    // Observe the notification of key board.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChangeFrameNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChangeFrameNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [_alertContentView removeObserver:self forKeyPath:[AXAlertView usingAutolayout]?@"containerView.bounds":@"containerView.frame"];
    [_actionSheetContentView removeObserver:self forKeyPath:[AXAlertView usingAutolayout]?@"containerView.bounds":@"containerView.frame"];
    [_alertContentView removeObserver:self forKeyPath:@"containerView.center"];
    [_actionSheetContentView removeObserver:self forKeyPath:@"containerView.center"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"containerView.bounds"] || [keyPath isEqualToString:@"containerView.frame"] || [keyPath isEqualToString:@"containerView.center"]) {
        // if (_shouldExceptArea) {
            // [self _enableExceptionArea];
            // Replaced with:
        [self _setupContentImageOfDimmingView];
        // }
    } else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(AXAlertControllerStyle)preferredStyle {
    AXAlertController *alert = [[self alloc] init];
    [alert _setStyle:preferredStyle];
    alert.alertView.title = title;
    alert.alertView.customView = alert.contentView;
    alert.contentView.contentLabel.text = message;
    return alert;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image preferredStyle:(AXAlertControllerStyle)preferredStyle {
    AXAlertController *alert = [self alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    alert.image = image;
    return alert;
}

#pragma mark - Overrides.
- (void)loadView {
    [super loadView];
    [self.view addSubview:self.keyboardAlignmentView];
    [self.view addSubview:self.underlyingView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_underlyingView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_underlyingView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_keyboardAlignmentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_keyboardAlignmentView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_underlyingView][_keyboardAlignmentView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_underlyingView, _keyboardAlignmentView)]];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_keyboardAlignmentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
    [_keyboardAlignmentView addConstraint:height];
    _heightOfKeyboardAlignment = height;
    
    [self _addContentViewToContainer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!_isViewDidAppear && !_isAlertShowsTranitionTriggered) {
        if (_style == AXAlertControllerStyleActionSheet) {
            [self _addContentViewToContainer];
            [self.alertView show:_animated];
        } else {
            [self.alertView show:_animated];
            if (_contentView.textFields.count > 0) {
                [_contentView.textFields.firstObject becomeFirstResponder];
            }
        }
        [self _setupContentImageOfDimmingView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isBeingPresented = [self isBeingPresented];
    _animated = animated;
}

- (void)viewWillMoveToSuperview:(UIView *)newSuperView {}
- (void)viewDidMoveToSuperview {}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _isViewDidAppear = YES;
    if (self.alertView.superview != self.underlyingView) {
        [self _addContentViewToView:self.underlyingView];
    }
}

#pragma mark - Public.
- (void)addAction:(AXAlertAction *)action {
    if (!_actions) _actions = [NSMutableArray array];
    [_actions addObject:action];
    
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
            [self.alertView setActionConfiguration:cancel forKey:_action.identifier];
        }
        [self.alertView appendActions:_action, nil];
    } else {
        AXAlertViewAction *_action = action.alertViewAction;
        [self.alertView appendActions:_action, nil];
    }
}

- (void)addAction:(AXAlertAction *)action configuration:(AXAlertActionConfiguration *)config {
    [self addAction:action];
    if (config) [self.alertView setActionConfiguration:config forKey:action.identifier.length?action.identifier:[NSString stringWithFormat:@"%@", @(_actions.count-1)]];
}

- (void)addAction:(AXAlertAction *)action configurationHandler:(void (^)(AXAlertActionConfiguration * _Nonnull))configuration {
    AXAlertActionConfiguration *config = [self.alertView.actionConfiguration copy];
    
    if (configuration != NULL) {
        configuration(config);
    }
    
    [self addAction:action configuration:config];
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler {
    NSAssert(_style == AXAlertControllerStyleAlert, @"Text fields configurations support only alert style.");
    [_contentView addTextFieldWithConfigurationHandler:configurationHandler];
    // Reset the inset of the custom view.
    UIEdgeInsets customViewInset = self.alertView.customViewInset;
    customViewInset.bottom = 12;
    [self.alertView setCustomViewInset:customViewInset];
}

#pragma mark - Getters.
- (AXAlertView *)alertView { return (_style==AXAlertControllerStyleActionSheet?self.actionSheetContentView:self.alertContentView); }
- (NSArray<AXAlertAction *> *)actions { return [_actions copy]; }
- (NSArray<UITextField *> *)textFields { return [_contentView.textFields copy]; }
- (NSString *)title { return _alertContentView.title; }
- (NSString *)message { return _contentView.contentLabel.text; }
- (UIImage *)image { return _contentView.imageView.image; }
- (AXAlertControllerStyle)preferredStyle { return _style; }

- (_AXAlertControllerContentView *)contentView {
    if (_contentView) return _contentView;
    _contentView = [_AXAlertControllerContentView new];
    return _contentView;
}

- (_AXAlertKeybboardAlignmentView *)keyboardAlignmentView {
    if (_keyboardAlignmentView) return _keyboardAlignmentView;
    _keyboardAlignmentView = [_AXAlertKeybboardAlignmentView new];
    _keyboardAlignmentView.translatesAutoresizingMaskIntoConstraints = NO;
    _keyboardAlignmentView.backgroundColor = [UIColor colorWithWhite:0 alpha:_opacity];
    return _keyboardAlignmentView;
}

- (_AXAlertControllerView *)underlyingView {
    if (_underlyingView) return _underlyingView;
    _underlyingView = [_AXAlertControllerView new];
    _underlyingView.translatesAutoresizingMaskIntoConstraints = NO;
    _underlyingView.userInteractionEnabled = YES;
    [_underlyingView setDelegate:self];
    // [_underlyingView setOpacity:0.4];
    [_underlyingView setContentMode:UIViewContentModeCenter];
    [_underlyingView setBackgroundColor:[UIColor clearColor]];
    [_underlyingView setClipsToBounds:YES];
    return _underlyingView;
}

- (_AXAlertControllerAlertContentView *)alertContentView {
    if (_alertContentView) return  _alertContentView;
    _alertContentView = [[_AXAlertControllerAlertContentView alloc] initWithFrame:self.underlyingView.bounds];
    [_alertContentView setBackgroundColor:[UIColor whiteColor]];
    _alertContentView.translatesAutoresizingMaskIntoConstraints = NO;
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
    
    [_alertContentView addObserver:self forKeyPath:[AXAlertView usingAutolayout]?@"containerView.bounds":@"containerView.frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_alertContentView addObserver:self forKeyPath:@"containerView.center" options:NSKeyValueObservingOptionNew context:NULL];
    return _alertContentView;
}

- (_AXAlertControllerSheetContentView *)actionSheetContentView {
    if (_actionSheetContentView) return _actionSheetContentView;
    _actionSheetContentView = [[_AXAlertControllerSheetContentView alloc] initWithFrame:self.underlyingView.bounds];
    [_actionSheetContentView setBackgroundColor:[UIColor whiteColor]];
    _actionSheetContentView.translatesAutoresizingMaskIntoConstraints = NO;
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
    
    [_actionSheetContentView addObserver:self forKeyPath:[AXAlertView usingAutolayout]?@"containerView.bounds":@"containerView.frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_actionSheetContentView addObserver:self forKeyPath:@"containerView.center" options:NSKeyValueObservingOptionNew context:NULL];
    return _actionSheetContentView;
}

#pragma mark - Setters.
- (void)setTitle:(NSString *)title {
    [_alertContentView setTitle:title];
}

- (void)setMessage:(NSString *)message {
    [_contentView.contentLabel setText:message];
}

- (void)setImage:(UIImage *)image {
    [_contentView.imageView setImage:image];
}

- (void)setModalTransitionStyle:(UIModalTransitionStyle)modalTransitionStyle {
    [super setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
}

- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    [super setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

#pragma mark - AXAlertViewDelegate.
- (void)alertViewWillShow:(AXAlertView *)alertView {
    _isAlertShowsTranitionTriggered = YES;// Disabled the more times show actions.
    if (_style == AXAlertControllerStyleActionSheet) {
        UIView *view = [_actionSheetContentView valueForKeyPath:@"animatingView"];
        [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:/*self.underlyingView.opacity*/_opacity]];
        [self.underlyingView addSubview:view];
    } else {
        if (!AX_ALERT_AVAILABLE_ON_PLATFORM(@"11.0.0")) {
            _translucent = self.alertView.translucent;
            self.alertView.translucent = NO;
            [self.contentView disableVisualEffects];
        }
    }
}

- (void)alertViewDidShow:(AXAlertView *)alertView {
    _isAlertShowsTranitionFinished = YES;
    if (!AX_ALERT_AVAILABLE_ON_PLATFORM(@"11.0.0")) {
        [self _updatedTranslucentState];
    }
}

- (void)alertViewWillHide:(AXAlertView *)alertView {
    if (_style == AXAlertControllerStyleActionSheet) {
        // [self _addContentViewToContainer];
        UIView *transitionView = [_actionSheetContentView valueForKeyPath:@"transitionView"];
        UIView *containerView = /*self.view.superview ?: self.underlyingView*/self.view.window;
        [containerView addSubview:transitionView];
    } else {
        if (!AX_ALERT_AVAILABLE_ON_PLATFORM(@"11.0.0")) {
            _translucent = self.alertView.translucent;
            self.alertView.translucent = NO;
            [self.contentView disableVisualEffects];
        }
    }
    [_contentView.textFields makeObjectsPerformSelector:@selector(resignFirstResponder)];
    [self _dismiss:alertView];
}

- (void)alertViewDidHide:(AXAlertView *)alertView {
    if (!AX_ALERT_AVAILABLE_ON_PLATFORM(@"11.0.0")) {
        [self _updatedTranslucentState];
    }
}

#pragma mark - Actions.
- (void)handleDeviceOrientationDidChangeNotification:(NSNotification *)aNote {
    // if (_style == AXAlertControllerStyleActionSheet) return;
    // [self _setShouldExceptArea:NO];
    // [self performSelector:@selector(_enableShouldExceptArea) withObject:nil afterDelay:0.3];
}
// UIKeyboardWillChangeFrameNotification
- (void)handleKeyboardWillChangeFrameNotification:(NSNotification *)aNote {
    CGRect keyboardFrame = [[[aNote userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[[aNote userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [[[aNote userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [self _updateContraintsOfAlignmentViewAndContentViewWithHeight:CGRectGetHeight(keyboardFrame) duration:duration curve:curve];
}

#pragma mark - Private.
- (void)_dismiss:(id)sender {
    if (_isBeingPresented) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)_setStyle:(uint64_t)arg { _style = arg; }

- (void)_setShouldExceptArea:(BOOL)arg {
    _shouldExceptArea = arg;
    // if (_shouldExceptArea) {
        // [self _enableExceptionArea];
    // } else {
        // [self _disableExceptionArea];
    //}
}
- (void)_enableShouldExceptArea __deprecated_msg("Using dimming content image instead.") {
    // [self _setShouldExceptArea:YES];
}

- (void)_addContentViewToContainer {
    UIView *containerView = self.view.superview ?: self.underlyingView;
    if (_style == AXAlertControllerStyleAlert) {
        containerView = self.underlyingView;
    }
    [self _addContentViewToView:containerView];
}

- (void)_addContentViewToView:(UIView *)view {
    if (self.alertView.superview) [self.alertView removeFromSuperview];
    [view addSubview:self.alertView];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [self.alertView _layoutSubviews];
    // [self _enableExceptionArea];
    // Replaced with:
    [self _setupContentImageOfDimmingView];
}

- (void)_enableExceptionArea __deprecated_msg("Using dimming content image instead.") { /*return;*/
    // [self.underlyingView setExceptionFrame:[[self.alertView valueForKeyPath:@"containerView.frame"] CGRectValue]];
    // [self.underlyingView setCornerRadius:self.alertView.cornerRadius];
    // [self.underlyingView setNeedsDisplay];
    UIImage *image = [AXAlertView _dimmingKnockoutImageOfExceptionRect:[[self.alertView valueForKeyPath:@"containerView.frame"] CGRectValue] cornerRadius:self.alertView.cornerRadius inRect:self.underlyingView.bounds opacity:_opacity];
    if (image) {
        [self.underlyingView setImage:image];
    }
}

- (void)_disableExceptionArea __deprecated_msg("Using dimming content image instead.") {
    // [self.underlyingView setExceptionFrame:CGRectZero];
    // [self.underlyingView setCornerRadius:.0];
    // [self.underlyingView setNeedsDisplay];
    [self.underlyingView setImage:nil];
}

- (void)_setupContentImageOfDimmingView {
    UIImage *image = [AXAlertView _dimmingKnockoutImageOfExceptionRect:[[self.alertView valueForKeyPath:@"containerView.frame"] CGRectValue] cornerRadius:self.alertView.cornerRadius inRect:self.underlyingView.bounds opacity:_opacity];
    if (image != nil) {
        [self.underlyingView setImage:image];
    }
}

- (void)_updatedTranslucentState {
    if (_translucent && _style == AXAlertControllerStyleAlert) {
        [self.alertView setTranslucent:_translucent];
        [self.contentView enableVisualEffects];
    }
}

- (BOOL)_shouldBeginTransitionOfKeyboardAlignmentView { return !_processingKeyboardAlignmentViewTransition; }
/// Update contraints of views by animated.
- (void)_updateContraintsOfAlignmentViewAndContentViewWithHeight:(CGFloat)height duration:(NSTimeInterval)duration curve:(NSUInteger)curve {
    if (![self _shouldBeginTransitionOfKeyboardAlignmentView]) return;
    _processingKeyboardAlignmentViewTransition = YES;
    _heightOfKeyboardAlignment.constant = height;
    
    if (!_isAlertShowsTranitionFinished) {
        [UIView setAnimationsEnabled:NO];
        self.underlyingView.clipsToBounds = NO;
        self.keyboardAlignmentView.hidden = YES;
        self.underlyingView.transform = CGAffineTransformMakeTranslation(0, height/2);
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:duration delay:0.0 options:curve|UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionOverrideInheritedOptions animations:^{
            self.underlyingView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                self.underlyingView.clipsToBounds = YES;
                self.keyboardAlignmentView.hidden = NO;
                _processingKeyboardAlignmentViewTransition = NO;
            }
        }];
    } else {
        _processingKeyboardAlignmentViewTransition = NO;
    }
}
@end
