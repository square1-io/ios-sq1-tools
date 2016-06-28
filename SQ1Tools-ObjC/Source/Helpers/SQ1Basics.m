//
//  SQ1Basics.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 28/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "SQ1Basics.h"

void sq1_executeOnMainThread(void (^block)())
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dispatch_queue_set_specific(dispatch_get_main_queue(), &onceToken, &onceToken, NULL);
  });
  
  if (dispatch_get_specific(&onceToken) == &onceToken) {
    block();
  } else {
    dispatch_async(dispatch_get_main_queue(), block);
  }
}