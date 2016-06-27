//
//  ReplaceRootControllerSegue.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "ReplaceRootControllerSegue.h"

@implementation ReplaceRootControllerSegue

- (void)perform
{
  CGFloat dur = 0.3;
  UIView *destView = [self.destinationViewController view];
  UIView *srcView = [self.sourceViewController view];
  
  id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];

  [appDelegate.window insertSubview:destView belowSubview:srcView];
  
  [UIView animateWithDuration:dur animations:^{
    srcView.alpha = 0.0;
    
  } completion:^(BOOL finished) {
    [appDelegate.window bringSubviewToFront:destView];
    appDelegate.window.rootViewController = self.destinationViewController;
  }];
}

@end
