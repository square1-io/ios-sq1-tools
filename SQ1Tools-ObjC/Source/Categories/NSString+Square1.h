//
//  NSString+Square1.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Square1)

- (BOOL)sq1_validEmail:(BOOL)strict;
- (NSDate *)sq1_dateWithFormat:(NSString *)dateFormat;
- (NSString*)sq1_trimmedString;
- (BOOL)sq1_empty;

- (NSString *)sq1_sha1WithKey:(NSString *)key secret:(NSString *)secret;
- (NSString *)sq1_base64EncodedString;

@end
