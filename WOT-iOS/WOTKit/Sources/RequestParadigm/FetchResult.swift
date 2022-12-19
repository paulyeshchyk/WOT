//
//  FetchResult.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias FetchResultCompletion = (FetchResult) -> Void
public typealias FetchResultErrorCompletion = (FetchResult, Error?) -> Void

@objc
public enum FetchConcurency: Int {
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
    func object(byID: AnyObject) -> AnyObject?
    func performBBlock(_ block: (() -> Void)?)
}

public protocol FetchResultProtocol: AnyObject {
    var fetchStatus: FetchStatus { get set }
    var predicate: NSPredicate? { get set }
    var objectContext: ObjectContextProtocol? { get set }
    func managedObject() -> ManagedObjectProtocol?
}

public protocol ManagedObjectProtocol: AnyObject {
    var entityName: String { get }
}

@objc
open class FetchResult: NSObject, NSCopying, FetchResultProtocol {
    public var objectContext: ObjectContextProtocol?
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?

    private var objectID: AnyObject?
    private var managedObjectContext: ObjectContextProtocol

    override public required init() {
        fatalError("")
    }

    override public var description: String {
        let entityName = managedObject()?.entityName ?? ""
        return "Context: \(managedObjectContext.name ?? ""); \(entityName)"
    }

    public required init(objectContext cntx: ObjectContextProtocol, objectID objID: AnyObject?, predicate predicat: NSPredicate?, fetchStatus status: FetchStatus) {
        managedObjectContext = cntx
        objectID = objID
        predicate = predicat
        fetchStatus = status
        
        objectContext = cntx
        super.init()
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FetchResult(objectContext: managedObjectContext, objectID: objectID, predicate: predicate, fetchStatus: fetchStatus)
        return copy
    }

    public func dublicate() -> FetchResult {
        // swiftlint:disable force_cast
        return copy() as! FetchResult
        // swiftlint:enable force_cast
    }

    public func managedObject() -> ManagedObjectProtocol? {
        return managedObject(inManagedObjectContext: objectContext)
    }

    public func managedObject(inManagedObjectContext context: ObjectContextProtocol?) -> ManagedObjectProtocol? {
        guard let objectID = objectID else {
            assertionFailure("objectID is not defined")
            return nil
        }
        return context?.object(byID: objectID) as? ManagedObjectProtocol
    }
}
