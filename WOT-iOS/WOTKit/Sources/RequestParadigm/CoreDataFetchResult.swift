//
//  FetchResult.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias CoreDataFetchResultCompletion = (CoreDataFetchResult) -> Void
public typealias CoreDataFetchResultErrorCompletion = (CoreDataFetchResult, Error?) -> Void

@objc
public enum WOTExecuteConcurency: Int {
    case mainQueue
    case privateQueue
}

@objc
public enum FetchStatus: Int {
    case none
    case fetched
    case inserted
    case updated
    case recovered
}

@objc
public protocol ObjectContextProtocol: AnyObject {
    var name: String? { get }
}

extension NSManagedObjectContext: ObjectContextProtocol {
    //
}

public protocol FetchResultProtocol: AnyObject {
    var fetchStatus: FetchStatus { get set }
    var predicate: NSPredicate? { get set }
    var objectContext: ObjectContextProtocol? { get set }
    func managedObject() -> ManagedObjectProtocol
}

public protocol ManagedObjectProtocol: AnyObject {
    var entityName: String { get }
}

extension NSManagedObject: ManagedObjectProtocol {
    public var entityName: String {
        return entity.name ?? "<unknown>"
    }
}

@objc
public class CoreDataFetchResult: NSObject, NSCopying, FetchResultProtocol {
    public var objectContext: ObjectContextProtocol?
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?

    private var objectID: NSManagedObjectID?
    private var managedObjectContext: ObjectContextProtocol

    override public required init() {
        fatalError("")
    }

    override public var description: String {
        return "Context: \(managedObjectContext.name ?? ""); \(managedObject().entityName)"
    }

    public required init(objectContext cntx: ObjectContextProtocol, objectID objID: NSManagedObjectID?, predicate predicat: NSPredicate?, fetchStatus status: FetchStatus) {
        managedObjectContext = cntx
        objectID = objID
        predicate = predicat
        fetchStatus = status
        
        objectContext = cntx
        super.init()
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = CoreDataFetchResult(objectContext: managedObjectContext, objectID: objectID, predicate: predicate, fetchStatus: fetchStatus)
        return copy
    }

    public func dublicate() -> CoreDataFetchResult {
        // swiftlint:disable force_cast
        return copy() as! CoreDataFetchResult
        // swiftlint:enable force_cast
    }

    public func managedObject() -> ManagedObjectProtocol {
        return managedObject(inManagedObjectContext: objectContext)
    }

    public func managedObject(inManagedObjectContext: ObjectContextProtocol?) -> NSManagedObject {
        guard let objectID = objectID else {
            fatalError("objectID is not defined")
        }
        guard let context = inManagedObjectContext as? NSManagedObjectContext else {
            fatalError("context is not NSManagedObjectContext")
        }
        return context.object(with: objectID)
    }
}

public class EmptyFetchResult: CoreDataFetchResult {
    public required convenience init() {
        let cntx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let objectID = NSManagedObjectID()
        self.init(objectContext: cntx, objectID: objectID, predicate: nil, fetchStatus: .none)
    }
}
