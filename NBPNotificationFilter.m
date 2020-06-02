//
//  NotificationFilter.m
//  thing
//
//  Created by Tomer Shemesh on 12/1/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBPNotificationFilter.h"

@implementation NotificationFilter
 
- (id)copyWithZone:(NSZone *)zone {
  NotificationFilter *copy = [[NotificationFilter allocWithZone:zone] init];
  copy.filterName = self.filterName;
  copy.filterText = self.filterText;
  copy.blockType = self.blockType;
  copy.appToBlock = self.appToBlock;
  copy.onSchedule = self.onSchedule;
  copy.startTime = self.startTime;
  copy.endTime = self.endTime;
  copy.weekDays = [NSMutableArray arrayWithArray:self.weekDays];
  copy.filterName = self.filterName;
  return copy;
}

- (id)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    self.filterName = [decoder decodeObjectForKey:@"filterName"];
    self.filterText = [decoder decodeObjectForKey:@"filterText"];
    self.blockType = [decoder decodeIntegerForKey:@"blockType"];
    self.appToBlock = [decoder decodeObjectForKey:@"appToBlock"];
    self.onSchedule = [decoder decodeBoolForKey:@"onSchedule"];
    self.startTime = [decoder decodeObjectForKey:@"startTime"];
    self.endTime = [decoder decodeObjectForKey:@"endTime"];
    self.weekDays = [decoder decodeObjectForKey:@"weekDays"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.filterName forKey:@"filterName"];
  [encoder encodeObject:self.filterText forKey:@"filterText"];
  [encoder encodeInteger:self.blockType forKey:@"blockType"];
  [encoder encodeObject:self.appToBlock forKey:@"appToBlock"];
  [encoder encodeBool:self.onSchedule forKey:@"onSchedule"];
  [encoder encodeObject:self.startTime forKey:@"startTime"];
  [encoder encodeObject:self.endTime forKey:@"endTime"];
  [encoder encodeObject:self.weekDays forKey:@"weekDays"];
}

@end
