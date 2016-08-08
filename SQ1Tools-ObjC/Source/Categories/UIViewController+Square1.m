//
//  UIViewController+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Roberto Pastor Ortiz on 8/8/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "UIViewController+Square1.h"

@implementation UIViewController (Square1)

-(void)sq1_showAlert:(NSString * _Nullable)message
               title:(NSString * _Nullable)title
{
  [self sq1_showAlert:message
                title:title
       confirmHandler:nil];
}

-(void)sq1_showAlert:(NSString * _Nullable)message
               title:(NSString * _Nullable)title
      confirmHandler:(void (^ _Nullable)(UIAlertAction * _Nullable))okHandler
{
  [self sq1_showAlert:message
                title:title
       confirmHandler:okHandler
        cancelHandler:nil];
}


-(void)sq1_showAlert:(NSString * _Nullable)message
               title:(NSString * _Nullable)title
      confirmHandler:(void (^ _Nullable)(UIAlertAction * _Nullable action))okHandler
       cancelHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))cancelHandler
{
  
  [self sq1_showAlert:message title:title
              okTitle:nil
          cancelTitle:nil
       confirmHandler:okHandler
        cancelHandler:cancelHandler];
}

-(void)sq1_showAlert:(NSString * _Nullable)message
               title:(NSString * _Nullable)title
             okTitle:(NSString * _Nullable)okTitle
         cancelTitle:(NSString * _Nullable)cancelTitle
      confirmHandler:(void (^ _Nullable)(UIAlertAction * _Nullable action))okHandler
       cancelHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))cancelHandler
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];

  NSString *ok = okTitle != nil ? okTitle : NSLocalizedString(@"OK", nil);
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok
                                                     style:UIAlertActionStyleDefault
                                                   handler:okHandler];
  [alert addAction:okAction];
  
  if (cancelHandler) {
    NSString *cancel = cancelTitle != nil ? cancelTitle : NSLocalizedString(@"Cancel", nil);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                           style:UIAlertActionStyleCancel
                                                         handler:cancelHandler];
    [alert addAction:cancelAction];
  }
  
  [self presentViewController:alert animated:YES completion:nil];
}








@end
