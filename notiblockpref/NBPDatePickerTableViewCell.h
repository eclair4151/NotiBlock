//
//  DatePickerTableViewCell.h
//  thing
//
//  Created by Tomer Shemesh on 11/28/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *selectedTimeLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
- (void)setPickerDate:(NSDate *)date;

@end
