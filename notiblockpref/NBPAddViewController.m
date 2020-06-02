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

@interface NBPAddViewController ()
@property UITableView *tableView;

@property TextEntryTableViewCell * filterNameCell;
@property PickerTableViewCell *blockTypePickerCell;
@property TextEntryTableViewCell * filterTextCell;
@property DatePickerTableViewCell *startTimeCell;
@property DatePickerTableViewCell *endTimeCell;
@property ButtonTableViewCell *appToBlockCell;
@property SwitchTableViewCell *scheduleSwitchCell;
@property WeekDayTableViewCell *weekDayCell;
@property AppInfo *selectedApp;

@end


@implementation NBPAddViewController

- (void)loadView {
    [super loadView];
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = cancelBtn;

    self.blockTypePickerCell = [[PickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickerCell"];
    self.blockTypePickerCell.delegate = self;
    
    self.filterTextCell = [[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterTextEntryCell"];
    self.filterTextCell.textField.delegate = self;
    self.filterTextCell.textField.placeholder = @"Filter Text";
    [self.filterTextCell.textField setReturnKeyType:UIReturnKeyDone];
    self.filterTextCell.textField.delegate = self;
    self.filterTextCell.textField.tag = 1;

    self.filterNameCell = [[TextEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterNameEntryCell"];
    self.filterNameCell.textField.placeholder = @"Filter Name";
    [self.filterNameCell.textField setReturnKeyType:UIReturnKeyNext];
    self.filterNameCell.textField.delegate = self;

    self.startTimeCell = [[DatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"startTimeCell"];
    self.startTimeCell.descriptionLabel.text = @"Start Time";
    
    self.endTimeCell = [[DatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"endTimeCell"];
    self.endTimeCell.descriptionLabel.text = @"End Time";

    self.appToBlockCell = [[ButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buttonCell"];
    
    self.scheduleSwitchCell = [[SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switchCell"];
    [self.scheduleSwitchCell setSwitchListener:self];
    
    self.weekDayCell = [[WeekDayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weekdayCell"];
    
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    int screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,screenWidth,screenHeight-64) style:UITableViewStyleGrouped];
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
        if (self.selectedApp != nil) {
            self.appToBlockCell.buttonTextLabel.text = self.selectedApp.appName;
        } else {
             self.appToBlockCell.buttonTextLabel.text = @"All Apps";
        }
        [self.scheduleSwitchCell.cellSwitch setOn:self.currentFilter.onSchedule];
        [self.startTimeCell setPickerDate:self.currentFilter.startTime];
        [self.endTimeCell setPickerDate:self.currentFilter.endTime];
        [self.weekDayCell  setWeekDays:[self.currentFilter.weekDays mutableCopy]];
        
    } else {
        self.title = @"New Notification Filter";
        self.currentFilter = [[NotificationFilter alloc] init];
        saveButtonText = @"Create";
    }
    UIBarButtonItem *saveButton  = [[UIBarButtonItem alloc] initWithTitle:saveButtonText style:UIBarButtonItemStylePlain target:self action:@selector(onTapSave:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = saveButton;

}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return self.filterNameCell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return self.blockTypePickerCell;
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        return self.filterTextCell;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        return self.appToBlockCell;
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        return self.scheduleSwitchCell;
    } else if (indexPath.section == 3 && indexPath.row == 1) {
        return self.startTimeCell;
    } else if (indexPath.section == 3 && indexPath.row == 2) {
        return self.endTimeCell;
    } else if (indexPath.section == 3 && indexPath.row == 3) {
        return self.weekDayCell;
    }
    return nil;
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 1;
        case 3:
            return (self.scheduleSwitchCell.cellSwitch.isOn ? 4 : 1);
        default:
            return 0;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (void)switchChanged:(UISwitch *)sender {
    [self dismissKeyboard];
    [self.tableView beginUpdates];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:1 inSection:3], [NSIndexPath indexPathForRow:2 inSection:3], [NSIndexPath indexPathForRow:3 inSection:3], nil];
    if (!sender.isOn) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    } else {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self toggleViewVisibility:self.blockTypePickerCell.picker];
    }else if (indexPath.section == 3 && indexPath.row == 1) {
        [self toggleViewVisibility:self.startTimeCell.datePicker];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else if (indexPath.section == 3 && indexPath.row == 2) {
        [self toggleViewVisibility:self.endTimeCell.datePicker];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else if (indexPath.section == 2) {
        [self dismissKeyboard];
        AppChooserViewController *vc = [[AppChooserViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        return (self.blockTypePickerCell.picker.tag == 0 ? 50 : 200);
    }else if (indexPath.section == 3 && indexPath.row == 1) {
        return (self.startTimeCell.datePicker.tag == 0 ? 50 : 200);
    } else if (indexPath.section == 3 && indexPath.row == 2) {
        return (self.endTimeCell.datePicker.tag == 0 ? 50 : 200);
    }
    return 50;
}

//block type picker
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //they selected always so disable the filter input
    if (row == 5) {
        self.filterTextCell.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        self.filterTextCell.textField.textColor = [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
        self.filterTextCell.textField.text = @"";
        self.filterTextCell.textField.enabled = NO;

    } else {
        self.filterTextCell.backgroundColor = [UIColor whiteColor];
        self.filterTextCell.textField.textColor = [UIColor blackColor];
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
        self.currentFilter.appToBlock = self.selectedApp;
        self.currentFilter.onSchedule = [self.scheduleSwitchCell.cellSwitch isOn];

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

