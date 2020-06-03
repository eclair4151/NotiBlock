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

        int screenWidth = [[UIScreen mainScreen] bounds].size.width;
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth * 0.27)];


        NSBundle *bundle = [[[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/NotiBlockPref.bundle"] autorelease];
        NSString *imagePath = [bundle pathForResource:@"example" ofType:@"png"];
        UIImage *myImage = [UIImage imageWithContentsOfFile:imagePath];
        self.cellImageView.image = myImage;

        self.cellImageView.backgroundColor =  [UIColor redColor];
        [self addSubview:self.cellImageView];
    }
    return self;
}


@end
