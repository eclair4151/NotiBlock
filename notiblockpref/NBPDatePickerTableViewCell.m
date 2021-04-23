//
//  DatePickerTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 11/28/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPDatePickerTableViewCell.h"

@implementation DatePickerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [self.contentView addSubview:self.descriptionLabel];

        self.selectedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.selectedTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.selectedTimeLabel];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        [self.datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
        self.datePicker.hidden = YES;
        
        [self.contentView addSubview:self.datePicker];
        [self dateIsChanged:self.datePicker];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    int screenWidth = self.frame.size.width;
    int vertHeight = 0;
    self.descriptionLabel.frame = CGRectMake(15, vertHeight, 150, 50);
    self.selectedTimeLabel.frame = CGRectMake(0, vertHeight, screenWidth - 15, 50);
    vertHeight+=50;
    self.datePicker.frame = CGRectMake(0, vertHeight, screenWidth, 150);
}


- (void)dateIsChanged:(id)sender{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    self.selectedTimeLabel.text = [outputFormatter stringFromDate:self.datePicker.date];
}

- (void)setPickerDate:(NSDate *)date {
    self.datePicker.date = date;
    [self dateIsChanged:self.datePicker];
}

@end
