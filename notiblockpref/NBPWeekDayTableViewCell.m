//
//  WeekDayTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPWeekDayTableViewCell.h"

@implementation WeekDayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.weekDaysSelected = [[NSMutableArray alloc] initWithCapacity:7];
        self.weekDayButtons = [[NSMutableArray alloc] initWithCapacity:7];

        NSArray *weekdays = [NSArray arrayWithObjects: @"Sun", @"Mon", @"Tue", @"Wed", @"Thu",@"Fri", @"Sat", nil];
        for (int i = 0; i < 7; i++) {
            UIButton *weekdayButton = [[UIButton alloc] initWithFrame:CGRectMake(i*(screenWidth/7+1), 0, (screenWidth/7 + 1), 50)];
            weekdayButton.tag = i;
            
            weekdayButton.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:236.0/255.0 blue:122.0/255.0 alpha:.54];
            
            [weekdayButton setTitle:weekdays[i] forState:UIControlStateNormal];
            [weekdayButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            [weekdayButton addTarget:self action:@selector(weekdayPressed:) forControlEvents:UIControlEventTouchUpInside];
            [weekdayButton.layer setBorderWidth:0.5];
            [weekdayButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
            [self.weekDayButtons addObject:weekdayButton];
            [self.weekDaysSelected addObject:[NSNumber numberWithBool:YES]];

            [self addSubview:weekdayButton];
            
        }
    }
    return self;
}

- (IBAction)weekdayPressed:(UIButton *)sender {
    NSInteger index = sender.tag;
    BOOL currentlySelected = [self.weekDaysSelected[index] boolValue];
    if (currentlySelected) {
        sender.backgroundColor = [UIColor colorWithRed:1.0 green:39.0/255.0 blue:51.0/255.0 alpha:.54];
    } else {
        sender.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:236.0/255.0 blue:122.0/255.0 alpha:.54];
    }
    
    self.weekDaysSelected[index] = [NSNumber numberWithBool:!currentlySelected];
}

-(void)setWeekDays:(NSMutableArray *)weekDays {
    self.weekDaysSelected = weekDays;
    for (int i = 0; i < 7; i++) {
        BOOL currentlySelected = [weekDays[i] boolValue];
        if (!currentlySelected) {
            ((UIButton *)self.weekDayButtons[i]).backgroundColor = [UIColor colorWithRed:1.0 green:39.0/255.0 blue:51.0/255.0 alpha:.54];
        } else {
            ((UIButton *)self.weekDayButtons[i]).backgroundColor = [UIColor colorWithRed:134.0/255.0 green:236.0/255.0 blue:122.0/255.0 alpha:.54];
        }
    }
}

@end
