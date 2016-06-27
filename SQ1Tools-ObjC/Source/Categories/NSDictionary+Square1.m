//
//  NSDictionary+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "NSDictionary+Square1.h"

@implementation NSDictionary (Square1)

- (id)sq1_get:(NSString *)key
{
  id object = [self objectForKey:key];
  
  if ([object isEqual:[NSNull null]]) {
    return nil;
  }
  
  return object;
}

@end
