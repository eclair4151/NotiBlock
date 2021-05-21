//
//  AppListTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPAppListTableViewCell.h"

@implementation AppListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.appIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [self.contentView addSubview:self.appIcon];

        self.appName = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        self.appName.numberOfLines = 1;
        [self.contentView addSubview:self.appName];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    int screenWidth = self.frame.size.width;
    self.appIcon.frame = CGRectMake(17.5, 7.5, 30, 30);
    self.appName.frame = CGRectMake(70, 0, screenWidth-70, 44);
}

@end

