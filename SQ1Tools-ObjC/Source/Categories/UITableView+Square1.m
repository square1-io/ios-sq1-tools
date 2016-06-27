//
//  UITableView+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "UITableView+Square1.h"
#import <objc/runtime.h>

static NSString* CACHE_KEY = @"CACHE_KEY";

@implementation UITableView (Square1)

- (UITableViewCell*)sq1_measureCellWithIdentifier:(NSString*)identifier
{
  return [[self cellCache] objectForKey:identifier];
}

- (void)sq1_registerCellType:(NSString*)cellType
{
  UINib* nib = [UINib nibWithNibName:cellType bundle:nil];
  id cell  = [[nib instantiateWithOwner:self options:nil] firstObject];
  [[self cellCache] setObject:cell forKey:cellType];
  [self registerNib:nib forCellReuseIdentifier:cellType];
}


-(NSMutableDictionary*)cellCache
{
  NSMutableDictionary* cellCache = objc_getAssociatedObject(self, &CACHE_KEY);
  
  if(cellCache == nil){
    cellCache = [[NSMutableDictionary alloc] init];
    objc_setAssociatedObject(self, &CACHE_KEY, cellCache, OBJC_ASSOCIATION_RETAIN);
  }
  
  return cellCache;
}
@end
