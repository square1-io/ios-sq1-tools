//
//  NSDate+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "NSDate+Square1.h"

#define kTimeZoneKey @"SQ1Tools-TimeZone"

@implementation NSDate (Square1)

- (NSString *)sq1_displayDateWithFormat:(NSString *)dateFormat
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:dateFormat];
  NSString *timeZone = [[NSBundle mainBundle] objectForInfoDictionaryKey:kTimeZoneKey];
  
  if (timeZone) {
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
  }
  
  return [dateFormatter stringFromDate:self];
}


@end