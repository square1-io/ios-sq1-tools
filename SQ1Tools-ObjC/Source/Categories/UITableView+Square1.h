//
//  UITableView+Square1.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

@import UIKit;

@interface UITableView (Square1)

- (UITableViewCell*)sq1_measureCellWithIdentifier:(NSString*)identifier;
- (void)sq1_registerCellType:(NSString*)cellType;

@end
