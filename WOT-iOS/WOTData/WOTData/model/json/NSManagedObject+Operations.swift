//
//  NSManagedObject+Operations.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 9/19/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData
@objc
extension NSManagedObject {

    @objc
    public static func singleObject(predicate: NSPredicate, inManagedObjectContext context: NSManagedObjectContext, includeSubentities: Bool) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        do {
            let result = try context.fetch(request)
            return result.last as? NSManagedObject
        } catch {
            return nil
        }
    }
}

/*

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

 */
