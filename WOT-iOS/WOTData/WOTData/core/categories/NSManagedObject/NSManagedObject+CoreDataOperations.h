//
//  NSManagedObject+CoreDataOperations.h
//  WOT-iOS
//
//  Created on 6/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CoreDataOperations)

+ (void)removeObjectsByPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
