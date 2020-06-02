//
//  PickerTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 12/1/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPPickerTableViewCell.h"

@implementation PickerTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.options = [NSArray arrayWithObjects:@"If it starts with:",@"If it ends with:",@"If it contains the text:",@"if it is the exact text:",@"If it matches regex:",@"Always",nil];
        int vertHeight = 0;
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, vertHeight, 200, 50)];
        self.descriptionLabel.text = @"Block the notification";
        [self addSubview:self.descriptionLabel];
        
        self.selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, vertHeight, screenWidth-15, 50)];
        self.selectedLabel.text = (NSString *)self.options[0];
        self.selectedLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.selectedLabel];
        vertHeight+=50;
        
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake((screenWidth - 225)/2, vertHeight, 225, 150)];
        self.picker.backgroundColor = [UIColor whiteColor];
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.picker.hidden = NO;
        self.picker.tag = 1;
        
        [self addSubview:self.picker];
        vertHeight += 150;
    }
    return self;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return (NSString *)self.options[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return self.options.count;
}

- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    self.selectedLabel.text = (NSString *)self.options[row];
    
    if (self.delegate) {
        [self.delegate pickerView:thePickerView didSelectRow:row inComponent:component];
    }
}

- (void)showAppPicker {
    
}

- (void)setPickerIndex:(NSInteger)index {
    [self.picker selectRow:index inComponent:0 animated:NO];
    self.selectedLabel.text = (NSString *)self.options[index];
    [self.delegate pickerView:self.picker didSelectRow:index inComponent:0];
    self.picker.hidden = YES;
    self.picker.tag = 0;
}

@end
