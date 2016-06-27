//
//  UUID.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "UUID.h"

#define kAccountNameKey @"SQ1Tools-UUIDAccountName"

@interface UUID ()

@property (nonatomic) OSStatus lastErrorStatus;
@property (nonatomic) NSString *accountName;

@end


@implementation UUID

+ (instancetype)sharedInstance
{
  static UUID *_instance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _instance = [[self alloc] init];
  });
  return _instance;
}

- (instancetype)init
{
  self = [super init];
  
  if (self) {
    _accountName = [[NSBundle mainBundle] objectForInfoDictionaryKey:kAccountNameKey];
    NSAssert(_accountName, @"An account name string should be inserted into the Info.plist file with key SQ1Tools-UUIDAccountName.");
  }
  
  return self;
}

- (NSString *)findOrCreate
{
  self.lastErrorStatus = noErr;
  NSString *UUIDString = [self find];
  if (UUIDString) return UUIDString;
  return [self create];
}


#pragma mark - Private

- (NSDictionary *)queryForFind
{
  return @{
           (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
           (__bridge id)kSecAttrAccount: self.accountName,
           (__bridge id)kSecAttrService: [NSBundle mainBundle].bundleIdentifier,
           (__bridge id)kSecReturnData: (__bridge id)kCFBooleanTrue
           };
}

- (NSDictionary *)queryForCreate:(NSString *)UUIDString
{
  return @{
           (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
           (__bridge id)kSecAttrAccount: self.accountName,
           (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlock,
           (__bridge id)kSecValueData: [UUIDString dataUsingEncoding:NSUTF8StringEncoding],
           (__bridge id)kSecAttrDescription: @"",
           (__bridge id)kSecAttrService: [NSBundle mainBundle].bundleIdentifier,
           (__bridge id)kSecAttrComment: @""
           };
}

- (NSString *)create
{
  NSString *UUIDString = [[[NSUUID alloc] init] UUIDString];
  OSStatus status = SecItemAdd((__bridge CFDictionaryRef)[self queryForCreate:UUIDString], NULL);
  if ([self verifyStatusAndStoreLastError:status]) return UUIDString;
  return nil;
}

- (NSString *)find
{
  CFDataRef result;
  OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)[self queryForFind], (CFTypeRef *)&result);
  if (![self verifyStatusAndStoreLastError:status]) return nil;
  
  NSData *data = (__bridge_transfer NSData *)result;
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)verifyStatusAndStoreLastError:(OSStatus)status
{
  BOOL isSuccess = (status == noErr);
  if (isSuccess) return YES;
  self.lastErrorStatus = status;
  return NO;
}

@end
