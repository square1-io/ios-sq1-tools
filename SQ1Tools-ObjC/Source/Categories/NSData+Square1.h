//
//  NSData+Square1.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

@import Foundation;

@interface NSData (Square1)

+ (NSData *)sq1_randomDataWithLength:(NSUInteger)length;
+ (NSData *)sq1_dataWithBase64EncodedString:(NSString *)string;

- (NSString *)sq1_stringValue;
- (NSString *)sq1_hexString;
- (NSString *)sq1_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)sq1_base64EncodedString;

- (NSData *)sq1_MD5Digest;

@end
