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
        self.buttonTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.buttonTextLabel.text = @"Select App To Filter...";
        [self.buttonTextLabel setTextColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        [self.contentView addSubview:self.buttonTextLabel];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    int screenWidth = self.frame.size.width;
    self.buttonTextLabel.frame = CGRectMake(15, 0, screenWidth, 44);
}


@end
