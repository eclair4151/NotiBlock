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
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:self.descriptionLabel];
        
        self.selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.selectedLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.selectedLabel];
        
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.picker.hidden = NO;
        self.picker.tag = 1;
        
        [self addSubview:self.picker];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    int screenWidth = self.frame.size.width;
    int vertHeight = 0;
    self.descriptionLabel.frame = CGRectMake(15, vertHeight, 200, 50);
    self.selectedLabel.frame = CGRectMake(0, vertHeight, screenWidth-15, 50);
    vertHeight+=50;
    self.picker.frame = CGRectMake((screenWidth - 225)/2, vertHeight, 225, 150);
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
