//
//  NSManagedObject+Operations.swift
//  WOTData
//
//  Created on 9/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    @objc
    public static func singleObject(predicate: NSPredicate?, inManagedObjectContext context: NSManagedObjectContext, includeSubentities: Bool) -> NSManagedObject? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.fetchLimit = 1
        request.predicate = predicate
        request.includesSubentities = includeSubentities
        do {
            return try context.fetch(request).last as? NSManagedObject
        } catch {
            print("singleObject error:\(error)")
        }
        return nil
    }

    @objc
    public static func insertNewObject(_ context: NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: self), into: context)
    }

    @objc
    public static func entityDescription(_ context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: self), in: context)
    }

    @objc
    public static func findOrCreateObject(predicate: NSPredicate?, context: NSManagedObjectContext) -> NSManagedObject? {
        guard let foundObject = self.singleObject(predicate: predicate, inManagedObjectContext: context, includeSubentities: false) else {
            return self.insertNewObject(context)
        }
        return foundObject
    }

    @objc
    public static func findOrCreateObject(forClass: AnyClass, predicate: NSPredicate?, context: NSManagedObjectContext?) -> NSManagedObject? {
        guard let context = context else {
            fatalError("context not defined")
        }
        guard let foundObject = forClass.singleObject(predicate: predicate, inManagedObjectContext: context, includeSubentities: false) else {
            return forClass.insertNewObject(context)
        }
        return foundObject
    }
}

public typealias NSManagedObjectCallback = (NSManagedObject?) -> Void
public typealias NSManagedObjectSetCallback = ([NSManagedObject?]?) -> Void

extension NSManagedObject: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case hasChanges
    }

    public typealias Fields = FieldKeys

    @objc
    open func mapping(fromArray array: [Any]) {
        fatalError("not implemented")
    }

    @objc
    open func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        fatalError("not implemented")
    }

    @objc
    open func mapping(fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        fatalError("not implemented")
    }
}
