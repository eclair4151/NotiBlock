//
//  ImageTableViewCell.m
//  thing
//
//  Created by Tomer Shemesh on 12/2/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPImageTableViewCell.h"

@implementation ImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];

        NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/NotiBlockPref.bundle"];
        NSString *imagePath = [bundle pathForResource:@"example" ofType:@"png"];
        UIImage *myImage = [UIImage imageWithContentsOfFile:imagePath];
        self.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.cellImageView.image = myImage;
        [self.contentView addSubview:self.cellImageView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    int screenWidth = self.frame.size.width;
    self.cellImageView.frame = CGRectMake(0, 0, screenWidth, screenWidth * 0.27);
}


@end
