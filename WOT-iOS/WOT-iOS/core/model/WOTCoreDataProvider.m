//
//  WOTCoreDataProvider.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "WOTCoreDataProvider.h"
#import "WOTError.h"

@interface WOTCoreDataProvider ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *workManagedObjectContext;

@end

@implementation WOTCoreDataProvider


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (WOTCoreDataProvider *)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        
        if ([NSThread isMainThread]) {
            instance = [[self alloc] init];
        } else {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                instance = [[self alloc] init];
            });
        }
        
    });
    return instance;
}

- (NSManagedObjectContext *)workManagedObjectContext {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [context setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        
        context.undoManager = nil;
        self.workManagedObjectContext = context;
        
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(workContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:context];
    });
    
    return _workManagedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [context setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        
        context.undoManager = nil;
        self.managedObjectContext = context;
        
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(mainContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:context];
    });
    
    return _managedObjectContext;
}



- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "py.WOT_iOS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WOT_iOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    
    // Create the coordinator and store
    
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WOT_iOS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        
        [[NSFileManager defaultManager] removeItemAtPath:[storeURL absoluteString] error:NULL];
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [WOTError coreDataErrorWithCode:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark -
- (void)mainContextDidSave:(NSNotification *)notification {
    
    [self.workManagedObjectContext performBlock:^{
        
        [self mergeChanges:notification toContext:self.workManagedObjectContext];
    }];
}

- (void)workContextDidSave:(NSNotification *)notification {
    
    [self.managedObjectContext performBlockAndWait:^{
        
        [self mergeChanges:notification toContext:self.managedObjectContext];
    }];
}

- (void)mergeChanges:(NSNotification *)notification toContext:(NSManagedObjectContext *)context {
    
    NSArray* updatedObjects = [notification.userInfo valueForKey:NSUpdatedObjectsKey];
    
    NSMutableSet *updatedObjectsInCurrentContext = [NSMutableSet new];
    
    for (NSManagedObject* obj in updatedObjects) {
        NSManagedObject* object = [context objectWithID:obj.objectID];
        [object willAccessValueForKey:nil];
        [updatedObjectsInCurrentContext addObject:object];
    }
    
    [context mergeChangesFromContextDidSaveNotification:notification];
    
    [updatedObjectsInCurrentContext addObjectsFromArray:[context.updatedObjects allObjects]];
    
    [updatedObjectsInCurrentContext enumerateObjectsUsingBlock:^(NSManagedObject *obj, BOOL *stop) {
        
        [context refreshObject:obj mergeChanges:YES];
    }];
    
    if ([context hasChanges]) {
        [context save:nil];
    } else {
        
        [context processPendingChanges];
    }
}

@end
