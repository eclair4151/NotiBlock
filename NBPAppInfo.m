//
//  AppInfo.m
//  thing
//
//  Created by Tomer Shemesh on 12/3/18.
//  Copyright © 2018 Tomer Shemesh. All rights reserved.
//

#import "NBAppInfo.h"

@implementation AppInfo


- (id)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    self.appName = [decoder decodeObjectForKey:@"appName"];
    self.appIdentifier = [decoder decodeObjectForKey:@"appIdentifier"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.appName forKey:@"appName"];
  [encoder encodeObject:self.appIdentifier forKey:@"appIdentifier"];
}

@end

