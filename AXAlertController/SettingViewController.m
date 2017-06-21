//
//  SettingViewController.m
//  AXAlertController
//
//  Created by devedbox on 2017/6/21.
//  Copyright © 2017年 devedbox. All rights reserved.
//

#import "SettingViewController.h"

@implementation SettingModel
@end

@interface SettingViewController ()
/// Setting model.
@property(strong, nonatomic) SettingModel *settings;
/// Translucent of alert.
@property(weak, nonatomic) IBOutlet UISwitch *alertTranslucentSwitch;
/// Hides on touch.
@property(weak, nonatomic) IBOutlet UISwitch *hidesOnTouchSwitch;
/// Show separators.
@property(weak, nonatomic) IBOutlet UISwitch *showsSeparatorsSwitch;
/// Translucent style segmented control.
@property(weak, nonatomic) IBOutlet UISegmentedControl *alertTranslucentStyleControl;
/// Padding slider.
@property(weak, nonatomic) IBOutlet UISlider *paddingSlider;
@property(weak, nonatomic) IBOutlet UILabel *paddingValueLabel;
/// Vertical offset slider.
@property(weak, nonatomic) IBOutlet UISlider *verticalOffsetSlider;
@property(weak, nonatomic) IBOutlet UILabel *verticalOffsetValueLabel;
/// Opacity slider.
@property(weak, nonatomic) IBOutlet UISlider *opacitySlider;
@property(weak, nonatomic) IBOutlet UILabel *opacityValueLabel;
/// Max allowed width slider.
@property(weak, nonatomic) IBOutlet UISlider *maxAllowedWidthSlider;
@property(weak, nonatomic) IBOutlet UILabel *maxAllowedWidthValueLabel;
/// Corner radius slider.
@property(weak, nonatomic) IBOutlet UISlider *cornerRadiusSlider;
@property(weak, nonatomic) IBOutlet UILabel *cornerRadiusValueLabel;
/// Translucent of action.
@property(weak, nonatomic) IBOutlet UISwitch *actionTranslucentSwitch;
/// Translucent style segmented control.
@property(weak, nonatomic) IBOutlet UISegmentedControl *actionTranslucentStyleControl;
/// Padding slider.
@property(weak, nonatomic) IBOutlet UISlider *actionPaddingSlider;
@property(weak, nonatomic) IBOutlet UILabel *actionPaddingValueLabel;
/// Padding slider.
@property(weak, nonatomic) IBOutlet UISlider *actionMarginSlider;
@property(weak, nonatomic) IBOutlet UILabel *actionMarginValueLabel;
#pragma mark - Prefered margin.
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *preferedMarginTopSlider;
@property(weak, nonatomic) IBOutlet UILabel *preferedMarginTopValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *preferedMarginLeftSlider;
@property(weak, nonatomic) IBOutlet UILabel *preferedMarginLeftValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *preferedMarginBottomSlider;
@property(weak, nonatomic) IBOutlet UILabel *preferedMarginBottomValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *preferedMarginRightSlider;
@property(weak, nonatomic) IBOutlet UILabel *preferedMarginRightValueLabel;
#pragma mark - Conent inset.
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *contentInsetTopSlider;
@property(weak, nonatomic) IBOutlet UILabel *contentInsetTopValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *contentInsetLeftSlider;
@property(weak, nonatomic) IBOutlet UILabel *contentInsetLeftValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *contentInsetBottomSlider;
@property(weak, nonatomic) IBOutlet UILabel *contentInsetBottomValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *contentInsetRightSlider;
@property(weak, nonatomic) IBOutlet UILabel *contentInsetRightValueLabel;
#pragma mark - Custom inset.
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *customInsetTopSlider;
@property(weak, nonatomic) IBOutlet UILabel *customInsetTopValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *customInsetLeftSlider;
@property(weak, nonatomic) IBOutlet UILabel *customInsetLeftValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *customInsetBottomSlider;
@property(weak, nonatomic) IBOutlet UILabel *customInsetBottomValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *customInsetRightSlider;
@property(weak, nonatomic) IBOutlet UILabel *customInsetRightValueLabel;
#pragma mark - Title inset.
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *titleInsetTopSlider;
@property(weak, nonatomic) IBOutlet UILabel *titleInsetTopValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *titleInsetLeftSlider;
@property(weak, nonatomic) IBOutlet UILabel *titleInsetLeftValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *titleInsetBottomSlider;
@property(weak, nonatomic) IBOutlet UILabel *titleInsetBottomValueLabel;
/// Content top slider.
@property(weak, nonatomic) IBOutlet UISlider *titleInsetRightSlider;
@property(weak, nonatomic) IBOutlet UILabel *titleInsetRightValueLabel;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    
    if (_delegate) {
        _settings = [_delegate originalSettingModel];
    } else {
        _settings = [SettingModel new];
    }
    
    [_alertTranslucentSwitch setOn:_settings.translucent];
    [_alertTranslucentStyleControl setSelectedSegmentIndex:_settings.translucentStyle];
    [_hidesOnTouchSwitch setOn:_settings.hidesOnTouch];
    [_showsSeparatorsSwitch setOn:_settings.showsSeparators];
    [_paddingSlider setValue:_settings.padding];
    [_paddingSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_verticalOffsetSlider setValue:_settings.verticalOffset];
    [_verticalOffsetSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_opacitySlider setValue:_settings.opacity];
    [_opacitySlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_maxAllowedWidthSlider setValue:_settings.maxAllowedWidth];
    [_maxAllowedWidthSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_cornerRadiusSlider setValue:_settings.cornerRadius];
    [_cornerRadiusSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
    [_actionTranslucentSwitch setOn:_settings.actionTranslucent];
    [_actionTranslucentStyleControl setSelectedSegmentIndex:_settings.actionTranslucentStyle];
    [_actionPaddingSlider setValue:_settings.actionPadding];
    [_actionPaddingSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_actionMarginSlider setValue:_settings.actionMargin];
    [_actionMarginSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
    [_preferedMarginTopSlider setValue:_settings.preferedMargin.top];
    [_preferedMarginTopSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_preferedMarginLeftSlider setValue:_settings.preferedMargin.left];
    [_preferedMarginLeftSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_preferedMarginBottomSlider setValue:_settings.preferedMargin.bottom];
    [_preferedMarginBottomSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_preferedMarginRightSlider setValue:_settings.preferedMargin.right];
    [_preferedMarginRightSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
    [_contentInsetTopSlider setValue:_settings.contentInset.top];
    [_contentInsetTopSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_contentInsetLeftSlider setValue:_settings.contentInset.left];
    [_contentInsetLeftSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_contentInsetBottomSlider setValue:_settings.contentInset.bottom];
    [_contentInsetBottomSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_contentInsetRightSlider setValue:_settings.contentInset.right];
    [_contentInsetRightSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
    [_customInsetTopSlider setValue:_settings.customViewInset.top];
    [_customInsetTopSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_customInsetLeftSlider setValue:_settings.customViewInset.left];
    [_customInsetLeftSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_customInsetBottomSlider setValue:_settings.customViewInset.bottom];
    [_customInsetBottomSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_customInsetRightSlider setValue:_settings.customViewInset.right];
    [_customInsetRightSlider sendActionsForControlEvents:UIControlEventValueChanged];
    
    [_titleInsetTopSlider setValue:_settings.titleInset.top];
    [_titleInsetTopSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_titleInsetLeftSlider setValue:_settings.titleInset.left];
    [_titleInsetLeftSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_titleInsetBottomSlider setValue:_settings.titleInset.bottom];
    [_titleInsetBottomSlider sendActionsForControlEvents:UIControlEventValueChanged];
    [_titleInsetRightSlider setValue:_settings.titleInset.right];
    [_titleInsetRightSlider sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions.
- (IBAction)done:(id)sender {
    if (_delegate) {
        _settings.translucent = _alertTranslucentSwitch.isOn;
        _settings.translucentStyle = _alertTranslucentStyleControl.selectedSegmentIndex;
        _settings.hidesOnTouch = _hidesOnTouchSwitch.isOn;
        _settings.showsSeparators = _showsSeparatorsSwitch.isOn;
        _settings.padding = _paddingSlider.value;
        _settings.verticalOffset = _verticalOffsetSlider.value;
        _settings.opacity = _opacitySlider.value;
        _settings.maxAllowedWidth = _maxAllowedWidthSlider.value;
        _settings.cornerRadius = _cornerRadiusSlider.value;
        
        _settings.actionTranslucent = _actionTranslucentSwitch.isOn;
        _settings.actionTranslucentStyle = _actionTranslucentStyleControl.selectedSegmentIndex;
        _settings.actionPadding = _actionPaddingSlider.value;
        _settings.actionMargin = _actionMarginSlider.value;
        
        _settings.preferedMargin = UIEdgeInsetsMake(_preferedMarginTopSlider.value, _preferedMarginLeftSlider.value, _preferedMarginBottomSlider.value, _preferedMarginRightSlider.value);
        _settings.contentInset = UIEdgeInsetsMake(_contentInsetTopSlider.value, _contentInsetLeftSlider.value, _contentInsetBottomSlider.value, _contentInsetRightSlider.value);
        _settings.customViewInset = UIEdgeInsetsMake(_customInsetTopSlider.value, _customInsetLeftSlider.value, _customInsetBottomSlider.value, _customInsetRightSlider.value);
        _settings.titleInset = UIEdgeInsetsMake(_titleInsetTopSlider.value, _titleInsetLeftSlider.value, _titleInsetBottomSlider.value, _titleInsetRightSlider.value);
        
        [_delegate settingViewControllerDidFinishConfiguring:_settings];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)handlePaddingSlider:(UISlider *)sender {
    [_paddingValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

- (IBAction)handleVerticalOffsetSlider:(UISlider *)sender {
    [_verticalOffsetValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

- (IBAction)handleOpacitySlider:(UISlider *)sender {
    [_opacityValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

- (IBAction)handleMaxAllowedWidthSlider:(UISlider *)sender {
    [_maxAllowedWidthValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

- (IBAction)handleCornerRadiusSlider:(UISlider *)sender {
    [_cornerRadiusValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

- (IBAction)handleActionPaddingSlider:(UISlider *)sender {
    [_actionPaddingValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

- (IBAction)handleActionMarginSlider:(UISlider *)sender {
    [_actionMarginValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

#pragma mark - Prefered Margin.
- (IBAction)handePreferedMarginTopSlider:(UISlider *)sender {
    [_preferedMarginTopValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handePreferedMarginLeftSlider:(UISlider *)sender {
    [_preferedMarginLeftValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handePreferedMarginBottomSlider:(UISlider *)sender {
    [_preferedMarginBottomValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handePreferedMarginRightSlider:(UISlider *)sender {
    [_preferedMarginRightValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

#pragma mark - Content Inset.
- (IBAction)handeContentInsetTopSlider:(UISlider *)sender {
    [_contentInsetTopValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeContentInsetLeftSlider:(UISlider *)sender {
    [_contentInsetLeftValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeContentInsetBottomSlider:(UISlider *)sender {
    [_contentInsetBottomValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeContentInsetRightSlider:(UISlider *)sender {
    [_contentInsetRightValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

#pragma mark - Custom Inset.
- (IBAction)handeCustomInsetTopSlider:(UISlider *)sender {
    [_customInsetTopValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeCustomInsetLeftSlider:(UISlider *)sender {
    [_customInsetLeftValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeCustomInsetBottomSlider:(UISlider *)sender {
    [_customInsetBottomValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeCustomInsetRightSlider:(UISlider *)sender {
    [_customInsetRightValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}

#pragma mark - Title Inset.
- (IBAction)handeTitleInsetTopSlider:(UISlider *)sender {
    [_titleInsetTopValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeTitleInsetLeftSlider:(UISlider *)sender {
    [_titleInsetLeftValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeTitleInsetBottomSlider:(UISlider *)sender {
    [_titleInsetBottomValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
- (IBAction)handeTitleInsetRightSlider:(UISlider *)sender {
    [_titleInsetRightValueLabel setText:[NSString stringWithFormat:@"%.2f", sender.value]];
}
@end
