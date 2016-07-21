//
//  SQ1CoreDataManager.h
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface SQ1CoreDataManager : NSObject


@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

+ (SQ1CoreDataManager *)sharedManager;

- (void)saveContextAndWait:(BOOL)wait
                completion:(void (^)(NSError *error))completion;

- (NSManagedObject *)newObjectInContext:(NSManagedObjectContext *)moc
                             entityName:(NSString *)entityName;
- (NSManagedObject *)newObjectInContextWithEntityName:(NSString *)entityName;


- (NSManagedObjectContext *)newChildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType;

- (void)deleteObject:(NSManagedObject *)object;

- (void)deleteObject:(NSManagedObject *)object
  saveContextAndWait:(BOOL)saveAndWait
          completion:(void (^)(NSError *error))completion;

- (NSFetchedResultsController *)fetchedResultsControllerEntitiesWithClassName:(NSString *)className
                                                              sortDescriptors:(NSArray *)sortDescriptors
                                                           sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                                    predicate:(NSPredicate *)predicate;

- (NSArray *)findAllObjectsWithClassName:(NSString *)className
                         sortDescriptors:(NSArray *)sortDescriptors
                               predicate:(NSPredicate *)predicate;

- (NSManagedObject *)findObjectWithClassName:(NSString *)className
                                   predicate:(NSPredicate *)predicate;

@end
