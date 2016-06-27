//
//  ResizedService.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

@import UIKit;

@interface ResizedService : NSObject

@property (nonatomic) NSString * _Nonnull host;
@property (nonatomic) NSString * _Nullable defaultImageURL;

+ (instancetype _Nullable)serviceWithKey:(NSString * _Nonnull)key
                                  secret:(NSString * _Nonnull)secret;

- (instancetype _Nullable)initWithKey:(NSString * _Nonnull)key
                               secret:(NSString * _Nonnull)secret;

- (NSString * _Nullable)resizeImage:(NSString * _Nonnull)imageURL
                           withSize:(CGSize)size;

@end
