//
//  NSManagedObject+Square1.h
//  SQ1Tools-ObjC
//
//  Created by Roberto Pastor Ortiz on 30/9/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Square1)

+ (instancetype)sq1_newObjectInContext:(NSManagedObjectContext *)moc;

+ (NSArray *)sq1_allInContext:(NSManagedObjectContext *)moc;

+ (NSArray *)sq1_findObjectsWithPredicate:(NSPredicate *)predicate
                       andSortDescriptors:(NSArray *)sortDescriptors
                                inContext:(NSManagedObjectContext *)moc;

+ (instancetype)sq1_findObjectWithPredicate:(NSPredicate *)predicate
                                  inContext:(NSManagedObjectContext *)moc;

+ (void)sq1_deleteAllInContext:(NSManagedObjectContext *)moc;



@end
