//
//  NSDate+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "NSDate+Square1.h"
#import "SQ1Constants.h"

@implementation NSDate (Square1)

+ (NSDate *)sq1_dateWithDate:(NSDate *)date
                     andTime:(NSDate *)time
{
  NSCalendar *calendar = [NSCalendar currentCalendar];
  
  NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
  NSDateComponents *timeComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:time];
  
  NSDateComponents *newDateComponents = [[NSDateComponents alloc] init];
  
  newDateComponents.year = dateComponents.year;
  newDateComponents.month = dateComponents.month;
  newDateComponents.day = dateComponents.day;
  newDateComponents.hour = timeComponents.hour;
  newDateComponents.minute = timeComponents.minute;
  newDateComponents.second = timeComponents.second;
  
  return [calendar dateFromComponents:newDateComponents];
}


+ (BOOL)sq1_is12hFormatEnabled
{
  NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j"
                                                                   options:0
                                                                    locale:[NSLocale currentLocale]];
  NSRange containsA = [formatStringForHours rangeOfString:@"a"];
  return containsA.location != NSNotFound;
}


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

- (NSString *)sq1_displayDateWithFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:dateFormat];
  
  if (timeZone) {
    [dateFormatter setTimeZone:timeZone];
  }
  
  return [dateFormatter stringFromDate:self];
}


@end
