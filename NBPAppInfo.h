//
//  AppInfo.h
//  thing
//
//  Created by Tomer Shemesh on 12/3/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppInfo : NSObject<NSCoding>

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appIdentifier;

@end


