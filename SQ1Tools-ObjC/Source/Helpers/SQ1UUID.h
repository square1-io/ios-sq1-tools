//
//  SQ1UUID.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

@import Foundation;
@import Security;

@interface SQ1UUID : NSObject

@property (nonatomic, readonly) OSStatus lastErrorStatus;

+ (instancetype)sharedInstance;
- (NSString *)findOrCreate;

@end
