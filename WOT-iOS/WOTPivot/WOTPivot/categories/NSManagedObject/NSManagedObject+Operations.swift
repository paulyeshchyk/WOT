//
//  NSManagedObject+Operations.swift
//  WOTData
//
//  Created on 9/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

@objc
extension NSManagedObject {
    @objc
    public static func singleObject(predicate: NSPredicate?, inManagedObjectContext context: NSManagedObjectContext, includeSubentities: Bool) -> NSManagedObject? {
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
    public static func findOrCreateObject(forClass: AnyClass, predicate: NSPredicate?, context: NSManagedObjectContext) -> NSManagedObject? {
        guard let foundObject = forClass.singleObject(predicate: predicate, inManagedObjectContext: context, includeSubentities: false) else {
            return forClass.insertNewObject(context)
        }
        return foundObject
    }
}

extension NSManagedObject: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case hasChanges
    }

    public typealias Fields = FieldKeys

    @objc
    open func mapping(fromArray array: [Any]) { fatalError("not implemented")}

    @objc
    open func mapping(fromJSON jSON: JSON, parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) { fatalError("not implemented")}

    @objc
    open func mapping(fromArray array: [Any], parentPrimaryKey: WOTPrimaryKey?, onSubordinateCreate: OnSubordinateCreateCallback?, linksCallback: OnLinksCallback?) { fatalError("not implemented")}
}
