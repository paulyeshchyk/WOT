//
//  NSManagedObject+CoreDataOperations.m
//  WOT-iOS
//
//  Created on 6/1/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "NSManagedObject+CoreDataOperations.h"
#import <WOTData/WOTData-Swift.h>

@implementation NSManagedObject (CoreDataOperations)

+ (void)removeObjectsByPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {

    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    request.entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:managedObjectContext];
    request.predicate = predicate;

    NSArray * result = [managedObjectContext executeFetchRequest:request error:NULL];
    for(NSManagedObject *obj in result) {

        [managedObjectContext deleteObject:obj];
    }
}

@end
