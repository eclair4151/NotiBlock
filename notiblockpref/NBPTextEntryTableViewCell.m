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

        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, screenWidth, 50)];
        self.textField.placeholder = @"Enter Filter Text Here";
        [self addSubview:self.textField];
    }
    return self;
}
@end
