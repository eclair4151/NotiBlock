//
//  WeekDayTableViewCell.h
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekDayTableViewCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *weekDayButtons;
@property (nonatomic, strong) NSMutableArray *weekDaysSelected;
-(void)setWeekDays:(NSMutableArray *)weekDays;

@end
