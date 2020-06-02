//
//  SwitchTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPSwitchTableViewCell.h"

@implementation SwitchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        int screenWidth = [[UIScreen mainScreen] bounds].size.width;

        self.switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 50)];
        self.switchLabel.text = @"Filter On Schedule";
        [self addSubview:self.switchLabel];
        
        
        self.cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(screenWidth-66, 9, 51, 31)];
        [self.cellSwitch setOn:NO animated:NO];
        [self addSubview:self.cellSwitch];


        
    }
    return self;
}

- (void) setSwitchListener:(UIViewController *)viewController {
    [self.cellSwitch addTarget:viewController action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}
@end
