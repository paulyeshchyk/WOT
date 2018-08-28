//
//  NSManagedObject+CoreDataOperations.h
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/1/15.
//  Copyright (c) 2015 Pavel Yeshchyk. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CoreDataOperations)

+ (instancetype)singleObjectWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext includingSubentities:(BOOL)includeSubentities;

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (void)removeObjectsByPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (instancetype)findOrCreateObjectWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
