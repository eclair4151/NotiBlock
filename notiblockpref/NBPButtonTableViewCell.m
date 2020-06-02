//
//  ButtonTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.buttonTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screenWidth, 50)];
        self.buttonTextLabel.text = @"Select App To Filter...";
        [self.buttonTextLabel setTextColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        [self addSubview:self.buttonTextLabel];
    }
    return self;
}
@end
