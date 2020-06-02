//
//  DatePickerTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 11/28/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPDatePickerTableViewCell.h"

@implementation DatePickerTableViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int vertHeight = 0;
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, vertHeight, 150, 50)];
        [self addSubview:self.descriptionLabel];

        self.selectedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, vertHeight, screenWidth - 15, 50)];
        self.selectedTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.selectedTimeLabel];
        vertHeight+=50;
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, vertHeight, screenWidth, 150)];
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        [self.datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
        self.datePicker.hidden = YES;
        
        [self addSubview:self.datePicker];
        [self dateIsChanged:self.datePicker];

        vertHeight += 150;
    }
    return self;
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
