//
//  SettingViewController.m
//  AXAlertController
//
//  Created by devedbox on 2017/6/21.
//  Copyright © 2017年 devedbox. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions.
- (IBAction)done:(id)sender {
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
