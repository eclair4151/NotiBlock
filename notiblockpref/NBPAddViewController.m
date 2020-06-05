//
//  ViewController.m
//  thing
//
//  Created by Tomer Shemesh on 11/28/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPAddViewController.h"
#import "NBPDatePickerTableViewCell.h"
#import "NBPPickerTableViewCell.h"
#import "NBPTextEntryTableViewCell.h"
#import "NBPButtonTableViewCell.h"
#import "NBPSwitchTableViewCell.h"
#import "NBPWeekDayTableViewCell.h"
#import "NBPAppChooserViewController.h"
#import "NBPImageTableViewCell.h"

@interface NBPAddViewController ()
@property UITableView *tableView;

@property TextEntryTableViewCell * filterNameCell;
@property ImageTableViewCell * notificationExampleViewCell;

@property PickerTableViewCell *notificationFilterFieldPickerCell;
@property PickerTableViewCell *blockTypePickerCell;
@property TextEntryTableViewCell * filterTextCell;
@property DatePickerTableViewCell *startTimeCell;
@property DatePickerTableViewCell *endTimeCell;
@property ButtonTableViewCell *appToBlockCell;
@property SwitchTableViewCell *whitelistSwitchCell;
@property SwitchTableViewCell *showInNotificationCenterSwitchCell;

@property SwitchTableViewCell *scheduleSwitchCell;
@property WeekDayTableViewCell *weekDayCell;
@property AppInfo *selectedApp;

@end


@implementation NBPAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelBtn;

    self.filterNameCell = [[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterNameEntryCell"];
    self.filterNameCell.textField.placeholder = @"Filter Name";
    [self.filterNameCell.textField setReturnKeyType:UIReturnKeyNext];
    self.filterNameCell.textField.delegate = self;

    self.notificationExampleViewCell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationExampleViewCell"];
    
    self.notificationFilterFieldPickerCell = [[PickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterFieldPickerCell"];
    self.notificationFilterFieldPickerCell.options = [NSArray arrayWithObjects:@"Any Field", @"The Title", @"The Subtitle", @"The Message",nil];
    self.notificationFilterFieldPickerCell.descriptionLabel.text = @"Block If";
    self.notificationFilterFieldPickerCell.selectedLabel.text = (NSString *)self.notificationFilterFieldPickerCell.options[0];
    self.notificationFilterFieldPickerCell.delegate = self;

    self.blockTypePickerCell = [[PickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blockTypePickerCell"];
    self.blockTypePickerCell.options = [NSArray arrayWithObjects:@"Starts with:",@"Ends with:",@"Contains the text:",@"Is the exact text:",@"Matches regex:",@"Always",nil];
    self.blockTypePickerCell.descriptionLabel.text = @"Filter Type";
    self.blockTypePickerCell.selectedLabel.text = (NSString *)self.blockTypePickerCell.options[0];
    self.blockTypePickerCell.delegate = self;


    self.filterTextCell = [[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterTextEntryCell"];
    self.filterTextCell.textField.delegate = self;
    self.filterTextCell.textField.placeholder = @"Filter Text";
    [self.filterTextCell.textField setReturnKeyType:UIReturnKeyDone];
    self.filterTextCell.textField.delegate = self;
    self.filterTextCell.textField.tag = 1;

    self.appToBlockCell = [[ButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buttonCell"];

    self.whitelistSwitchCell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"whitelistswitchCell"];
    self.whitelistSwitchCell.switchLabel.text = @"Whitelist Mode";
    [self.whitelistSwitchCell setSwitchListener:self];

    self.showInNotificationCenterSwitchCell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showinnotificationswitchCell"];
    self.showInNotificationCenterSwitchCell.switchLabel.text = @"Show In Notification Center";
    [self.showInNotificationCenterSwitchCell setSwitchListener:self];
    
    self.scheduleSwitchCell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scheduleswitchCell"];
    self.scheduleSwitchCell.switchLabel.text = @"Block on Schedule";
    [self.scheduleSwitchCell setSwitchListener:self];

    self.startTimeCell = [[DatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startTimeCell"];
    self.startTimeCell.descriptionLabel.text = @"Start Time";
    
    self.endTimeCell = [[DatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endTimeCell"];
    self.endTimeCell.descriptionLabel.text = @"End Time";

    self.weekDayCell = [[WeekDayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weekdayCell"];
    


    int screenHeight = self.view.frame.size.height;
    int screenWidth = self.view.frame.size.width;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,screenWidth,screenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    NSString *saveButtonText = @"";
    if (self.currentFilter != nil) {
        saveButtonText = @"Save";
        self.title = @"Edit Notification Filter";

        self.selectedApp = self.currentFilter.appToBlock;
        self.filterNameCell.textField.text = self.currentFilter.filterName;
        self.filterTextCell.textField.text = self.currentFilter.filterText;
        [self.blockTypePickerCell setPickerIndex:self.currentFilter.blockType];
        [self.notificationFilterFieldPickerCell setPickerIndex:self.currentFilter.filterType];

        if (self.selectedApp != nil) {
            self.appToBlockCell.buttonTextLabel.text = self.selectedApp.appName;
        } else {
             self.appToBlockCell.buttonTextLabel.text = @"All Apps";
        }
        [self.scheduleSwitchCell.cellSwitch setOn:self.currentFilter.onSchedule];
        [self.whitelistSwitchCell.cellSwitch setOn:self.currentFilter.whitelistMode];
        [self.showInNotificationCenterSwitchCell.cellSwitch setOn:self.currentFilter.showInNotificationCenter];

        [self.startTimeCell setPickerDate:self.currentFilter.startTime];
        [self.endTimeCell setPickerDate:self.currentFilter.endTime];
        [self.weekDayCell  setWeekDays:[self.currentFilter.weekDays mutableCopy]];
        
    } else {
        self.title = @"New Notification Filter";
        self.currentFilter = [[NotificationFilter alloc] init];
        [self.notificationFilterFieldPickerCell setPickerIndex:0];
        saveButtonText = @"Create";
    }
    UIBarButtonItem *saveButton  = [[UIBarButtonItem alloc] initWithTitle:saveButtonText style:UIBarButtonItemStylePlain target:self action:@selector(onTapSave:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = saveButton;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return self.filterNameCell;
        case 1:
            return self.notificationExampleViewCell;
        case 2:
            switch (indexPath.row) {
                case 0:
                    return self.notificationFilterFieldPickerCell;
                case 1: 
                    return self.blockTypePickerCell;
                case 2:
                    return self.filterTextCell;
            }
        case 3:
            return self.appToBlockCell;
        case 4:
            return self.whitelistSwitchCell;
        case 5:
            return self.showInNotificationCenterSwitchCell;
        case 6:
            switch (indexPath.row) {
                case 0:
                    return self.scheduleSwitchCell;
                case 1: 
                    return self.startTimeCell;
                case 2:
                    return self.endTimeCell;
                case 3:
                    return self.weekDayCell;
            }
    }
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Filter Name";
        case 1:
            return @"Notification Example";
        case 2:
            return @"Notification Filter Settings";
        case 3:
            return @"App To Filter";
        case 4:
            return @"By Setting Whitelist Mode to true, only notifications that match your filter they will be allowed, all others will be blocked. Note if you use a whitelist filter, you cannot combine with any other filters for that app. If you need to whitelist multiple things, you will need to use regex. Ex, set whitelist to true, select regex filter, and enter “^(Tomer:|Alex:)” would block all notifications from an app that didn’t start with Tomer: or Alex: blocking everyone else out.";
        case 5:
            return @"By turning Show In Notification Center to true, the notification will not make a sound, wake your phone, or show a banner, but will still show up in the notification center/lockscreen.";
        case 6:
            return @"When blocking on a schedule, The filter is only active in between the start time and end time on days that are selected as green. If the notification happens on a day that is red, or outside the window, it will be allowed through.";
    }  
    return @"";  
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 3;
        case 3:
            return 1;
        case 4:
            return 1;
        case 5:
            return 1;
        case 6:
            return (self.scheduleSwitchCell.cellSwitch.isOn ? 4 : 1);
        default:
            return 0;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (void)switchChanged:(UISwitch *)sender {
    [self dismissKeyboard];

    if (sender == self.scheduleSwitchCell.cellSwitch) {
        [self.tableView beginUpdates];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:1 inSection:6], [NSIndexPath indexPathForRow:2 inSection:6], [NSIndexPath indexPathForRow:3 inSection:6], nil];
        if (!sender.isOn) {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        } else {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:6] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } else if (sender == self.whitelistSwitchCell.cellSwitch) {

    } else if (sender == self.showInNotificationCenterSwitchCell.cellSwitch) {
        
    }
}


- (void)toggleViewVisibility:(UIView *)view {
    BOOL currentlyShowing = (view.tag == 1);
    view.tag = !view.tag;

    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    

    [UIView animateWithDuration:0.25
                     animations:^{
                         view.alpha = (currentlyShowing ? 0.0f : 1.0f);
                     }
                     completion:^(BOOL finished){
                         view.hidden = (currentlyShowing ? YES : NO);
                     }];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self toggleViewVisibility:self.notificationFilterFieldPickerCell.picker];
    } if (indexPath.section == 2 && indexPath.row == 1) {
        [self toggleViewVisibility:self.blockTypePickerCell.picker];
    } else if (indexPath.section == 6 && indexPath.row == 1) {
        [self toggleViewVisibility:self.startTimeCell.datePicker];
    } else if (indexPath.section == 6 && indexPath.row == 2) {
        [self toggleViewVisibility:self.endTimeCell.datePicker];
    } else if (indexPath.section == 3) {
        [self dismissKeyboard];
        AppChooserViewController *vc = [[AppChooserViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) { 
        return (self.notificationFilterFieldPickerCell.picker.tag == 0 ? 50 : 200);
    } if (indexPath.section == 2 && indexPath.row == 1) { 
        return (self.blockTypePickerCell.picker.tag == 0 ? 50 : 200);
    } else if (indexPath.section == 6 && indexPath.row == 1) {
        return (self.startTimeCell.datePicker.tag == 0 ? 50 : 200);
    } else if (indexPath.section == 6 && indexPath.row == 2) {
        return (self.endTimeCell.datePicker.tag == 0 ? 50 : 200);
    } else if (indexPath.section == 1) {
        return self.view.frame.size.width * 0.27; 
    }
    return 50;
}







//block type picker
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //they selected always so disable the filter input
    if (row == 5) {
        self.filterTextCell.textField.text = @"-----";
        self.filterTextCell.textField.enabled = NO;

    } else {
        if ([self.filterTextCell.textField.text isEqualToString: @"-----"]) {
            self.filterTextCell.textField.text = @"";
        }
        self.filterTextCell.textField.enabled = YES;
    }
}

- (void)hideViewVisibility:(UIView *)view {
    view.tag = 0;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         view.hidden = YES;
                     }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [self hideViewVisibility:self.blockTypePickerCell.picker];
    }
}

-(void)onTapSave:(UIBarButtonItem*)item{

    BOOL has1Weekday = false;
    for(int i =0; i < 7; i++) {
        if ([self.weekDayCell.weekDaysSelected[i] boolValue]) {
            has1Weekday = true;
            break;
        }
    }
    //first we have to do some validation

    if (![self.filterNameCell.textField hasText]) {
        [self alertUser:@"Missing Filter Name"];
    } else if ([self.blockTypePickerCell.picker selectedRowInComponent:0] != 5 && ![self.filterTextCell.textField hasText]) {
        [self alertUser:@"Missing Filter Text"];
    // } else if ([self.scheduleSwitchCell.cellSwitch isOn] && [[self.startTimeCell.datePicker.date earlierDate:self.endTimeCell.datePicker.date] isEqualToDate:self.endTimeCell.datePicker.date]) {
    //     [self alertUser:@"The Start Time must be before the End Time"];
    //
    } else if ([self.scheduleSwitchCell.cellSwitch isOn] && !has1Weekday) {
        [self alertUser:@"You must select at least 1 day for your filter to be active on"];
    } else {
        self.currentFilter.filterName = self.filterNameCell.textField.text;
        self.currentFilter.filterText = self.filterTextCell.textField.text;
        self.currentFilter.blockType = [self.blockTypePickerCell.picker selectedRowInComponent:0];
        self.currentFilter.filterType = [self.notificationFilterFieldPickerCell.picker selectedRowInComponent:0];
        self.currentFilter.appToBlock = self.selectedApp;
        self.currentFilter.onSchedule = [self.scheduleSwitchCell.cellSwitch isOn];
        self.currentFilter.whitelistMode = [self.whitelistSwitchCell.cellSwitch isOn];
        self.currentFilter.showInNotificationCenter = [self.showInNotificationCenterSwitchCell.cellSwitch isOn];

        self.currentFilter.startTime = self.startTimeCell.datePicker.date;
        self.currentFilter.endTime = self.endTimeCell.datePicker.date;
        self.currentFilter.weekDays = self.weekDayCell.weekDaysSelected;

        [self.delegate newFilter:self.currentFilter];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)onTapCancel:(UIBarButtonItem*)item{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)appChosen:(AppInfo *)app {
    self.selectedApp = app;
    if (app != nil) {
        self.appToBlockCell.buttonTextLabel.text = app.appName;
    } else {
        self.appToBlockCell.buttonTextLabel.text = @"All Apps";
    }
}

-(void)dismissKeyboard {
        [self.filterTextCell.textField resignFirstResponder];
        [self.filterNameCell.textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if (textField.tag == 0) {
        self.filterTextCell.textField.delegate = nil;
        [self.filterTextCell.textField becomeFirstResponder];
        self.filterTextCell.textField.delegate = self;
    } else if (textField.tag == 1) {
        [self dismissKeyboard];
        [self hideViewVisibility:self.blockTypePickerCell.picker];
    }
    return YES;
}

- (void)alertUser:(NSString *)alertMessage
{
     UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:alertMessage
                                 preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                }];

    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"Title";
//}


@end

