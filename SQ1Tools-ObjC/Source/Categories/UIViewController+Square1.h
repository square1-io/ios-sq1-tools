//
//  UIViewController+Square1.h
//  SQ1Tools-ObjC
//
//  Created by Roberto Pastor Ortiz on 8/8/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Square1)

-(void)sq1_showAlert:(NSString * _Nullable)message
               title:(NSString * _Nullable)title
      confirmHandler:(void (^ _Nullable)(UIAlertAction * _Nullable action))okHandler
       cancelHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))cancelHandler;

-(void)sq1_showAlert:(NSString * _Nullable)message
               title:(NSString * _Nullable)title
             okTitle:(NSString * _Nullable)okTitle
         cancelTitle:(NSString * _Nullable)cancelTitle
      confirmHandler:(void (^ _Nullable)(UIAlertAction * _Nullable action))okHandler
       cancelHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))cancelHandler;

-(void)sq1_showAlert:(NSString * _Nullable)message
               title:(NSString * _Nullable)title
      confirmHandler:(void (^ _Nullable)(UIAlertAction * _Nullable))okHandler;

-(void)sq1_showAlert:(NSString * _Nullable)message
               title:(NSString * _Nullable)title;

@end
