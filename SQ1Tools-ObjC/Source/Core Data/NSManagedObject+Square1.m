//
//  NSManagedObject+Square1.m
//  SQ1Tools-ObjC
//
//  Created by Roberto Pastor Ortiz on 30/9/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "NSManagedObject+Square1.h"

@implementation NSManagedObject (Square1)

+ (instancetype)sq1_newObjectInContext:(NSManagedObjectContext *)moc
{
  NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
                                            inManagedObjectContext:moc];
  
  return [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:moc];
}

+ (NSArray *)sq1_allInContext:(NSManagedObjectContext *)moc
{
  return [self sq1_findObjectsWithPredicate:nil
                         andSortDescriptors:nil
                                  inContext:moc];
}

+ (NSArray *)sq1_findObjectsWithPredicate:(NSPredicate *)predicate
                       andSortDescriptors:(NSArray *)sortDescriptors
                                inContext:(NSManagedObjectContext *)moc
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
                                            inManagedObjectContext:moc];
  fetchRequest.entity = entity;
  
  if (sortDescriptors != nil) {
    fetchRequest.sortDescriptors = sortDescriptors;
  }
  
  if (predicate != nil) {
    fetchRequest.predicate = predicate;
  }
  
  NSError *error = nil;
  NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
  
  if (error) {
    NSLog(@"sq1_findObjectsWithPredicate ERROR: %@", error.localizedDescription);
  }
  
  return results;
}

+ (instancetype)sq1_findObjectWithPredicate:(NSPredicate *)predicate
                                  inContext:(NSManagedObjectContext *)moc
{
  NSArray *results = [self sq1_findObjectsWithPredicate:predicate
                                     andSortDescriptors:nil
                                              inContext:moc];
  return results.firstObject;
}

+ (void)sq1_deleteAllInContext:(NSManagedObjectContext *)moc
{
  NSArray *allObjects = [self sq1_allInContext:moc];
  
  for (NSManagedObject *object in allObjects) {
    [moc deleteObject:object];
  }
}

@end
