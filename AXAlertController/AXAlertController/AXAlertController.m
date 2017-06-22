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

@interface _AXAlertContentBackgroundView: UIView
/// Text field.
@property(readwrite, nonatomic) _AXAlertTextfield *textfield;
/// Effect view.
@property(strong, nonatomic) UIVisualEffectView *effectView;
/// Effect mask view.
@property(strong, nonatomic) UIImageView *effectMasksView;
/// Background color view.
@property(strong, nonatomic) UIImageView *backgroundColorView;
/// Overrides light effect.
@property(assign, nonatomic) BOOL overridesLightStyle;
@end
@interface _AXAlertControllerContentView: UIView <UITextFieldDelegate>
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
/// Translucent.
@property(assign, nonatomic) BOOL translucent;
/// Translucent style.
@property(assign, nonatomic) AXAlertViewTranslucentStyle translucentStyle;

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

@implementation _AXAlertContentBackgroundView
- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.overridesLightStyle = YES;
        [self addSubview:self.effectView];
        [self addSubview:self.backgroundColorView];
        if ([AXAlertView usingAutolayout]) {
            _effectView.translatesAutoresizingMaskIntoConstraints = NO;
            _backgroundColorView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectView)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectView)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0.5-[_backgroundColorView]-0.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundColorView)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.5-[_backgroundColorView]-0.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundColorView)]];
        }
    } return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize susize = [super sizeThatFits:size];
    [self layoutSubviews];
    susize.height = CGRectGetHeight(self.bounds);
    return susize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (![AXAlertView usingAutolayout]) {
        CGSize sizeOfTxf = CGSizeMake(CGRectGetWidth(self.bounds)-10, _textfield.font.pointSize);
        CGFloat heightOfSelf = sizeOfTxf.height + 10;
        
        CGRect rect = self.frame;
        rect.size.height = heightOfSelf;
        [self setFrame:rect];
        
        [_effectView setFrame:self.bounds];
        [_effectMasksView setFrame:_effectView.bounds];
        [_backgroundColorView setFrame:CGRectMake(0.5, 0.5, CGRectGetWidth(self.bounds)-1, CGRectGetHeight(self.bounds)-1)];
        [_textfield setFrame:CGRectMake(5, 5, sizeOfTxf.width, sizeOfTxf.height)];
    }
}

- (void)setTextfield:(_AXAlertTextfield *)textfield {
    _textfield = textfield;
    [self addSubview:_textfield];
    if ([AXAlertView usingAutolayout]) {
        _textfield.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_textfield]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textfield)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_textfield]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textfield)]];
    } else {
        [self setNeedsLayout];
    }
}

- (void)setOverridesLightStyle:(BOOL)overridesLightStyle {
    _overridesLightStyle = overridesLightStyle;
    [self _resetEffectView];
}

- (UIVisualEffectView *)effectView {
    if (_effectView) return _effectView;
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]]];
    [_effectView.contentView addSubview:self.effectMasksView];
    if ([AXAlertView usingAutolayout]) {
        _effectView.translatesAutoresizingMaskIntoConstraints = NO;
        _effectMasksView.translatesAutoresizingMaskIntoConstraints = NO;
        [_effectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_effectMasksView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectMasksView)]];
        [_effectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_effectMasksView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectMasksView)]];
    }
    return _effectView;
}

- (UIImageView *)effectMasksView {
    if (_effectMasksView) return _effectMasksView;
    _effectMasksView = [UIImageView new];
    [_effectMasksView setBackgroundColor:[UIColor clearColor]];
    _effectMasksView.layer.borderWidth = 0.5;
    _effectMasksView.layer.borderColor = [UIColor whiteColor].CGColor;
    return _effectMasksView;
}

- (UIImageView *)backgroundColorView {
    if (_backgroundColorView) return _backgroundColorView;
    _backgroundColorView = [UIImageView new];
    _backgroundColorView.backgroundColor = [UIColor whiteColor];
    return _backgroundColorView;
}

- (void)_resetEffectView {
    if (_effectView) {
        [_effectView removeFromSuperview];
    }
    _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:_overridesLightStyle?UIBlurEffectStyleExtraLight:UIBlurEffectStyleDark]]];
    [_effectView.contentView addSubview:self.effectMasksView];
    if ([AXAlertView usingAutolayout]) {
        _effectView.translatesAutoresizingMaskIntoConstraints = NO;
        _effectMasksView.translatesAutoresizingMaskIntoConstraints = NO;
        [_effectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_effectMasksView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectMasksView)]];
        [_effectView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_effectMasksView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectMasksView)]];
    }
    [self insertSubview:_effectView atIndex:0];
    if ([AXAlertView usingAutolayout]) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_effectView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_effectView)]];
    }
}
@end
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
    [self layoutSubviews];
    susize.height = CGRectGetHeight(self.bounds);
    return susize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (![AXAlertView usingAutolayout]) {
        // Calculate size of content label.
        CGSize sizeOfContentLabel = CGSizeMake(CGRectGetWidth(self.bounds), .0);
        if (_contentLabel.numberOfLines == 0) {
            [_contentLabel sizeToFit];
            sizeOfContentLabel.height = CGRectGetHeight(_contentLabel.bounds);
        } else {
            CGSize size = [_contentLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentLabel.font} context:NULL].size;
            sizeOfContentLabel.height = ceil(size.height);
        }
        // Calculate size of image view.
        CGSize sizeOfImageView = CGSizeMake(CGRectGetWidth(self.bounds), .0);
        sizeOfImageView.height = _imageView.image.size.height;
        
        CGRect rect_contentLabel = _contentLabel.frame;
        rect_contentLabel.size = sizeOfContentLabel;
        _contentLabel.frame = rect_contentLabel;
        
        CGRect rect_imageView = _imageView.frame;
        rect_imageView.origin.y = CGRectGetHeight(rect_contentLabel)+_padding;
        rect_imageView.size = sizeOfImageView;
        _imageView.frame = rect_imageView;
        
        CGFloat height = CGRectGetMaxY(rect_imageView);
        
        // Set up frames of text fields.
        for (int i = 0; i < _textFields.count; i++) {
            _AXAlertTextfield *txf = (_AXAlertTextfield *)[_textFields objectAtIndex:i];
            _AXAlertContentBackgroundView *_bgnView = [self viewWithTag:i+1];
            CGSize sizeOfBgnView = CGSizeMake(CGRectGetWidth(self.bounds), .0);
            sizeOfBgnView.height += 5*2;
            sizeOfBgnView.height += txf.font.pointSize;
            CGFloat originY = .0;
            if (i == 0) {
                originY = CGRectGetMaxY(rect_imageView) + _padding;
            } else {
                originY = CGRectGetMaxY([self viewWithTag:i].frame) + _padding;
            }
            CGRect rect = CGRectMake(0, originY, sizeOfBgnView.width, sizeOfBgnView.height);
            [_bgnView setFrame:rect];
            
            if (i == _textFields.count - 1) {
                height = CGRectGetMaxY(rect);
            }
        }
        
        CGRect rect = self.frame;
        rect.size.height = height;
        [self setFrame:rect];
    }
}

#pragma mark - Public.
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler {
    _AXAlertTextfield *textField = [_AXAlertTextfield new];
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:13];
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType = UIReturnKeyNext;
    textField.delegate = self;
    
    if (configurationHandler) {
        configurationHandler(textField);
    }
    if ([AXAlertView usingAutolayout]) {
        _AXAlertContentBackgroundView * _textBackgroundView = [_AXAlertContentBackgroundView new];
        [_textBackgroundView setTextfield:textField];
        [_stackView addArrangedSubview:_textBackgroundView];
        [_textFields addObject:textField];
    } else {
        _AXAlertContentBackgroundView * _textBackgroundView = [_AXAlertContentBackgroundView new];
        [_textBackgroundView setTextfield:textField];
        _textBackgroundView.tag = _textFields.count+1;
        [self addSubview:_textBackgroundView];
        [_textFields addObject:textField];
        [self setNeedsLayout];
    }
}

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    if (_translucent) {
        [self enableVisualEffects];
    } else {
        [self disableVisualEffects];
    }
}

- (void)setTranslucentStyle:(AXAlertViewTranslucentStyle)translucentStyle {
    _translucentStyle = translucentStyle;
    if ([AXAlertView usingAutolayout]) {
        for (UIView *view in self.stackView.arrangedSubviews) {
            if ([view isKindOfClass:[_AXAlertContentBackgroundView class]]) {
                _AXAlertContentBackgroundView *_bgnView = (_AXAlertContentBackgroundView *)view;
                [_bgnView setOverridesLightStyle:_translucentStyle == AXAlertViewTranslucentLight];
            }
        }
    } else {
        for (int i = 0; i < _textFields.count; i++) {
            _AXAlertContentBackgroundView *_bgnView = [self viewWithTag:i+1];
            [_bgnView setOverridesLightStyle:_translucentStyle == AXAlertViewTranslucentLight];
        }
    }
}

- (void)disableVisualEffects {
    if ([AXAlertView usingAutolayout]) {
        for (UIView *view in self.stackView.arrangedSubviews) {
            if ([view isKindOfClass:[_AXAlertContentBackgroundView class]]) {
                _AXAlertContentBackgroundView *_bgnView = (_AXAlertContentBackgroundView *)view;
                _bgnView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
                _bgnView.layer.borderWidth = 0.5;
                [_bgnView.effectView setHidden:YES];
            }
        }
    } else {
        for (int i = 0; i < _textFields.count; i++) {
            _AXAlertContentBackgroundView *_bgnView = [self viewWithTag:i+1];
            _bgnView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
            _bgnView.layer.borderWidth = 0.5;
            [_bgnView.effectView setHidden:YES];
        }
    }
}

- (void)enableVisualEffects {
    if ([AXAlertView usingAutolayout]) {
        for (UIView *view in self.stackView.arrangedSubviews) {
            if ([view isKindOfClass:[_AXAlertContentBackgroundView class]]) {
                _AXAlertContentBackgroundView *_bgnView = (_AXAlertContentBackgroundView *)view;
                _bgnView.layer.borderColor = [UIColor clearColor].CGColor;
                _bgnView.layer.borderWidth = 0.0;
                [_bgnView.effectView setHidden:NO];
            }
        }
    } else {
        for (int i = 0; i < _textFields.count; i++) {
            _AXAlertContentBackgroundView *_bgnView = [self viewWithTag:i+1];
            _bgnView.layer.borderColor = [UIColor clearColor].CGColor;
            _bgnView.layer.borderWidth = 0.0;
            [_bgnView.effectView setHidden:NO];
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
    } else {
        [self setNeedsLayout];
    }
}

#pragma mark - UITextFieldDelegate.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        NSUInteger index = [_textFields indexOfObject:textField];
        if (index != NSNotFound) {
            if (index == _textFields.count-1) index = 0; else {
                index++;
            }
            
            UITextField *_nextTextfield = [_textFields objectAtIndex:index];
            if (_nextTextfield && [_nextTextfield canBecomeFirstResponder]) [_nextTextfield becomeFirstResponder];
        }
    }
    return NO;
}
#pragma mark - Private.
- (void)_addContraintsOfStackViewToSelf {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_stackView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stackView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView)]];
}
@end

@interface AXAlertController () <AXAlertViewDelegate> {
    BOOL _isBeingPresented;// Whether the alert controller is being presented.
    BOOL _isViewDidAppear;// Whether the view controller's view did appear.
    BOOL _animated;// Whether showing transition is animated or not.
    BOOL _isAlertShowsTranitionTriggered;// Whether the alert view has showed any once.
    BOOL _isAlertShowsTranitionFinished;// Whether the alert view did finish showing transition animation.
    
    BOOL _translucent;// Tmp storage of the translucent of the alert view.
    BOOL _shouldExceptArea  __deprecated_msg("Using dimming content image instead.");
    /// Indicator is the keyboard alignment view is in animating or not. YES when animation is in processing, otherwise NO.
    BOOL _processingKeyboardAlignmentViewTransition;
    
    float _opacity; // Defaults to 0.4.
    NSLayoutConstraint *__weak _heightOfKeyboardAlignment;// Height layout contraint of the keyboard alignment view.
    
    AXAlertControllerStyle _style;// Style of the alert controller.
    NSMutableArray<AXAlertAction *> *_actions;// Alert actions of the alert view.
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
    [_alertContentView removeObserver:self forKeyPath:@"translucent"];
    [_alertContentView removeObserver:self forKeyPath:@"translucentStyle"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"containerView.bounds"] || [keyPath isEqualToString:@"containerView.frame"] || [keyPath isEqualToString:@"containerView.center"]) {
        // if (_shouldExceptArea) {
            // [self _enableExceptionArea];
            // Replaced with:
        [self _setupContentImageOfDimmingView];
        // }
    } else if ([keyPath isEqualToString:@"translucent"]) {
        BOOL translucent = [change[NSKeyValueChangeNewKey] boolValue];
        [self.contentView setTranslucent:translucent];
    } else if ([keyPath isEqualToString:@"translucentStyle"]) {
        NSUInteger style = [change[NSKeyValueChangeNewKey] integerValue];
        [self.contentView setTranslucentStyle:style];
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

- (void)configureImageViewWithHandler:(void (^)(UIImageView * _Nonnull))handler {
    if (handler != NULL) {
        handler(_contentView.imageView);
    }
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
    
    [self _setupContentImageOfDimmingView];// Update the dimming background content image.
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
            cancel.preferredHeight = 44;
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
    _alertContentView.cornerRadius = [AXAlertView usingAutolayout]?12.0:6;
    _alertContentView.actionItemMargin = 0;
    _alertContentView.actionItemPadding = 0;
    _alertContentView.titleLabel.numberOfLines = 0;
    _alertContentView.preferredMargin = UIEdgeInsetsMake(0, 25, 0, 25);
    _alertContentView.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _alertContentView.titleLabel.textColor = [UIColor blackColor];
    AXAlertViewActionConfiguration *config = [AXAlertViewActionConfiguration new];
    config.backgroundColor = [UIColor whiteColor];
    config.preferredHeight = 44;
    config.cornerRadius = .0;
    config.tintColor = [UIColor blackColor];
    config.font = [UIFont systemFontOfSize:16];
    [_alertContentView setActionConfiguration:config];
    
    [_alertContentView addObserver:self forKeyPath:[AXAlertView usingAutolayout]?@"containerView.bounds":@"containerView.frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_alertContentView addObserver:self forKeyPath:@"containerView.center" options:NSKeyValueObservingOptionNew context:NULL];
    [_alertContentView addObserver:self forKeyPath:@"translucent" options:NSKeyValueObservingOptionNew context:NULL];
    [_alertContentView addObserver:self forKeyPath:@"translucentStyle" options:NSKeyValueObservingOptionNew context:NULL];
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
    _actionSheetContentView.cornerRadius = [AXAlertView usingAutolayout]?12.0:6;
    _actionSheetContentView.actionItemMargin = 0;
    _actionSheetContentView.actionItemPadding = 0;
    _actionSheetContentView.titleLabel.numberOfLines = 0;
    _actionSheetContentView.preferredMargin = UIEdgeInsetsMake(52, 52, 52, 52);
    _actionSheetContentView.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _actionSheetContentView.titleLabel.textColor = [UIColor blackColor];
    AXAlertViewActionConfiguration *config = [AXAlertViewActionConfiguration new];
    config.backgroundColor = [UIColor whiteColor];
    config.preferredHeight = 44;
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
