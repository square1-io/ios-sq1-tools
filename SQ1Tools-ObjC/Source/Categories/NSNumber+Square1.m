//
//  NSNumber+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "NSNumber+Square1.h"

@implementation NSNumber (Square1)

- (NSString *)sq1_formatAsCurrency:(NSString *)currencyCode
{
  NSNumberFormatter *numberFormatter =[[NSNumberFormatter alloc] init];
  [numberFormatter setCurrencyCode:currencyCode];
  numberFormatter.groupingSeparator = @",";
  numberFormatter.decimalSeparator = @".";
  return [numberFormatter stringFromNumber:self];
}

@end
