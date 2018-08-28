//
//  NSManagedObject+CoreDataOperations.m
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import "NSManagedObject+CoreDataOperations.h"
#import <WOTPivot/WOTPivot.h>

@implementation NSManagedObject (CoreDataOperations)

+ (instancetype)singleObjectWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext includingSubentities:(BOOL)includeSubentities {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.fetchLimit = 1;
    request.entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:managedObjectContext];
    request.predicate = predicate;
    [request setIncludesSubentities:includeSubentities];
    
    return [[managedObjectContext executeFetchRequest:request error:NULL] lastObject];
}

+ (void)removeObjectsByPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:managedObjectContext];
    request.predicate = predicate;
    
    NSArray * result = [managedObjectContext executeFetchRequest:request error:NULL];
    for(NSManagedObject *obj in result) {
        
        [managedObjectContext deleteObject:obj];
    }
}

+ (instancetype)findOrCreateObjectWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObject *result = [self singleObjectWithPredicate:predicate inManagedObjectContext:managedObjectContext includingSubentities:NO];
    if (!result){
        
        result = [self insertNewObjectInManagedObjectContext:managedObjectContext];
    } else {
        if ([[result class] isSubclassOfClass:NSClassFromString(@"Vehicleprofile")]) {
            debugLog(@"has found dublicate");
        }
    }
    return result;
}

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:managedObjectContext];
}

@end
