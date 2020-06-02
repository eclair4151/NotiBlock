//
//  PickerTableViewCell.h
//  thing
//
//  Created by Tomer Shemesh on 12/1/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerTableViewCell : UITableViewCell<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) id <UIPickerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *options;
- (void)setPickerIndex:(NSInteger)index;

@end
