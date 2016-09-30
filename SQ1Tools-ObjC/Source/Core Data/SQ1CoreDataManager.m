//
//  SQ1CoreDataManager.m
//  SQ1Tools-ObjC
//
//  Created by Rober Pastor on 27/6/16.
//  Copyright © 2016 Square1. All rights reserved.
//

#import "SQ1CoreDataManager.h"
#import "NSManagedObject+Square1.h"
#import "SQ1Constants.h"

@interface SQ1CoreDataManager()

@property (nonatomic) NSString *modelName;

@property (nonatomic, strong, readwrite) NSManagedObjectContext *context;

@property (nonatomic, strong) NSManagedObjectContext *writerContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;
@property (nonatomic, strong) NSManagedObjectModel *model;

@property (nonatomic, copy) NSString *storeType;
@property (nonatomic, strong) NSURL *storeURL;


@end

@implementation SQ1CoreDataManager

static SQ1CoreDataManager *coreDataManager;

#pragma mark - Lifecycle and setup

+ (SQ1CoreDataManager *)sharedManager;
{
  if (!coreDataManager) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      coreDataManager = [[SQ1CoreDataManager alloc] init];
    });
  }
  
  return coreDataManager;
}

- (instancetype)init
{
  self = [super self];
  
  if (self) {
    _modelName = [[NSBundle mainBundle] objectForInfoDictionaryKey:kModelNameKey];
    NSAssert(_modelName, @"A model name string should be inserted into the Info.plist file with key SQ1Tools-CoreDataModelName.");
    [self setupManagedObjectContext];
  }
  
  return self;
}



- (void)setupManagedObjectContext
{
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName
                                            withExtension:@"momd"];
  _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  NSAssert(_model, @"Managed Object Model is nil");
  
  _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
  
  NSAssert(_psc, @"Persistent Store Coordinator is nil");
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", _modelName]];
  NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES};
  
  NSError *error = nil;
  if(![self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = error.localizedFailureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    // Delete the faulty data
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:storeURL error:&error];
    
    // Recreate persistent store
    [self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
  }
  
  _writerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
  [_writerContext setPersistentStoreCoordinator:_psc];
  
  _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [_context setParentContext:_writerContext];
}

#pragma  mark - Private

- (NSURL *)applicationDocumentsDirectory
{
  NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask];
  return urls.lastObject;
}


- (BOOL)managedObjectContextHasChanges:(NSManagedObjectContext *)context
{
  __block BOOL hasChanges;
  
  [context performBlockAndWait:^{
    hasChanges = [context hasChanges];
  }];
  
  return hasChanges;
  
}


- (void(^)())savePrivateWriterContextBlockWithCompletion:(void (^)(NSError *))completion
{
  
  void (^savePrivate)(void) = ^{
    
    NSError *privateContextError = nil;
    if ([self.writerContext save:&privateContextError] == NO) {
      
      NSLog(@"ERROR: Could not save managed object context - %@\n%@", [privateContextError localizedDescription], [privateContextError userInfo]);
      if (completion) {
        completion(privateContextError);
      }
    } else {
      if (completion) {
        completion(nil);
      }
    }
  };
  
  return savePrivate;
}

#pragma mark - Public methods

- (NSManagedObjectContext *)newChildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
  NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
  [moc setParentContext:_writerContext];
  return moc;
}

- (void)saveContextAndWait:(BOOL)wait completion:(void (^)(NSError *))completion
{
  if ([self managedObjectContextHasChanges:self.context] || [self managedObjectContextHasChanges:self.writerContext]) {
    
    [self.context performBlockAndWait:^{
      
      NSError *mainContextSaveError = nil;
      if ([self.context save:&mainContextSaveError] == NO) {
        
        NSLog(@"ERROR: Could not save managed object context -  %@\n%@", [mainContextSaveError localizedDescription], [mainContextSaveError userInfo]);
        if (completion) {
          completion(mainContextSaveError);
        }
        return;
      }
      
      if ([self managedObjectContextHasChanges:self.writerContext]) {
        
        if (wait) {
          [self.writerContext performBlockAndWait:[self savePrivateWriterContextBlockWithCompletion:completion]];
        } else {
          [self.writerContext performBlock:[self savePrivateWriterContextBlockWithCompletion:completion]];
        }
        
        return;
      }
      
      if (completion) {
        completion(nil);
      }
    }];
  } else {
    
    if (completion) {
      completion(nil);
    }
  }
  
}




#pragma mark - New Object

- (NSManagedObject *)newObjectInContextWithEntityName:(NSString *)entityName
{
  return [self newObjectInContext:self.context entityName:entityName];
}

- (NSManagedObject *)newObjectInContext:(NSManagedObjectContext *)moc
                             entityName:(NSString *)entityName
{
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
                                                       inManagedObjectContext:moc];
  
  NSManagedObject *newObject = [[NSManagedObject alloc] initWithEntity:entityDescription
                                        insertIntoManagedObjectContext:moc];
  
  return newObject;
}


#pragma mark - Delete Object

- (void)deleteObject:(NSManagedObject *)object
{
  [self.context deleteObject:object];
}

- (void)deleteObject:(NSManagedObject *)object saveContextAndWait:(BOOL)saveAndWait completion:(void (^)(NSError *error))completion
{
  [self.context deleteObject:object];
  [self saveContextAndWait:saveAndWait completion:completion];
}


#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsControllerEntitiesWithClassName:(NSString *)className
                                                              sortDescriptors:(NSArray *)sortDescriptors
                                                           sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                                    predicate:(NSPredicate *)predicate
{
  NSFetchedResultsController *fetchedResultsController;
  NSFetchRequest *fetchRequest = [self fetchRequestWithClassName:className
                                                 sortDescriptors:sortDescriptors
                                                       predicate:predicate];
  
  fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:self.context
                                                                   sectionNameKeyPath:sectionNameKeypath
                                                                            cacheName:nil];
  return fetchedResultsController;
}


- (NSArray *)findAllObjectsWithClassName:(NSString *)className
                         sortDescriptors:(NSArray *)sortDescriptors
                               predicate:(NSPredicate *)predicate
{
  NSFetchRequest *fetchRequest = [self fetchRequestWithClassName:className
                                                 sortDescriptors:sortDescriptors
                                                       predicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
  
  if (error) {
    NSLog(@"findAllObjectsWithClassName ERROR: %@", error.localizedDescription);
  }
  
  return results;
}

- (NSManagedObject *)findObjectWithClassName:(NSString *)className
                                   predicate:(NSPredicate *)predicate
{
  return [self findObjectWithClassName:className
                       sortDescriptors:nil
                             predicate:predicate];
}

- (NSManagedObject *)findObjectWithClassName:(NSString *)className
                             sortDescriptors:(NSArray *)sortDescriptors
                                   predicate:(NSPredicate *)predicate
{
  NSArray *results = [self findAllObjectsWithClassName:className
                                       sortDescriptors:sortDescriptors
                                             predicate:predicate];
  return results.firstObject;
}

#pragma mark - Private

- (NSFetchRequest *)fetchRequestWithClassName:(NSString *)className
                              sortDescriptors:(NSArray *)sortDescriptors
                                    predicate:(NSPredicate *)predicate
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                            inManagedObjectContext:self.context];
  fetchRequest.entity = entity;
  fetchRequest.sortDescriptors = sortDescriptors;
  fetchRequest.predicate = predicate;
  
  return fetchRequest;
}


@end
