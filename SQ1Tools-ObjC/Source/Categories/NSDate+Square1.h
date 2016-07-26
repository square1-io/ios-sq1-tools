//
//  NSDate+Square1.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

@import Foundation;

@interface NSDate (Square1)

- (NSString *)sq1_displayDateWithFormat:(NSString *)dateFormat;
- (NSString *)sq1_displayDateWithFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone;

@end
