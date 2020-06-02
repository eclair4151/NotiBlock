//
//  NotificationFilter.h
//  thing
//
//  Created by Tomer Shemesh on 12/1/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBPAppInfo.h"

@interface NotificationFilter : NSObject <NSCopying>

@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) NSString *filterText;
@property (nonatomic) NSInteger blockType;
@property (nonatomic, strong) AppInfo *appToBlock;
@property (nonatomic) BOOL onSchedule;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSArray *weekDays;
-(id) copyWithZone: (NSZone *) zone;
-(NSDictionary *)encodeToDictionary;
- (id)initWithDictionary:(NSDictionary *)dict;

@end

