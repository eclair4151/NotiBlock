//
//  TextEntryTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPTextEntryTableViewCell.h"

@implementation TextEntryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    int screenWidth = self.frame.size.width;
    self.textField.frame = CGRectMake(15, 0, screenWidth, 50);
}

@end
