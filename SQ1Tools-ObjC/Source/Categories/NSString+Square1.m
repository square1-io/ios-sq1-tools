//
//  NSString+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "NSString+Square1.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Square1.h"

#define kTimeZoneKey @"SQ1Tools-TimeZone"

@implementation NSString (Square1)


- (BOOL)sq1_validEmail:(BOOL)strict
{
  BOOL stricterFilter = strict; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
  NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
  NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:self];
}


- (NSDate *)sq1_dateWithFormat:(NSString *)dateFormat
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:dateFormat];
  NSString *timeZone = [[NSBundle mainBundle] objectForInfoDictionaryKey:kTimeZoneKey];
  
  if (timeZone) {
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
  }
  
  return [dateFormatter dateFromString:self];
}

- (NSString*)sq1_trimmedString
{
  return  [self stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)sq1_empty
{
  return [[self stringByReplacingOccurrencesOfString:@"\\s" withString:@""
                                             options:NSRegularExpressionSearch
                                               range:NSMakeRange(0, [self length])] length] == 0;
}

- (NSString *)sq1_sha1WithKey:(NSString *)key secret:(NSString *)secret
{
  NSString* input =[NSString stringWithFormat:@"%@%@%@", key, secret, self];
  
  const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
  NSData *data = [NSData dataWithBytes:cstr length:input.length];
  
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  
  CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
  
  NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  
  return output;
}

- (NSString *)sq1_base64EncodedString
{
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
  return [data sq1_base64EncodedString];
}

@end
