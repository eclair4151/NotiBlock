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

        self.switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.contentView addSubview:self.switchLabel];
        
        self.cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.cellSwitch setOn:NO animated:NO];
        [self.contentView addSubview:self.cellSwitch];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat screenWidth = self.frame.size.width;
    self.switchLabel.frame = CGRectMake(15, 0, 250, 44);
    
    self.cellSwitch.center = self.contentView.center;
    CGRect switchFrame = self.cellSwitch.frame;
    switchFrame.origin.x = screenWidth-66;
    self.cellSwitch.frame = switchFrame;
}


- (void) setSwitchListener:(UIViewController *)viewController {
    [self.cellSwitch addTarget:viewController action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}
@end
