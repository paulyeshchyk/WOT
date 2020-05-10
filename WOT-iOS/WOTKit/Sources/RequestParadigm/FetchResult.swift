//
//  FetchResult.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias FetchResultCompletion = (FetchResult) -> Void
public typealias FetchResultErrorCompletion = (FetchResult, Error?) -> Void

@objc
public enum WOTExecuteConcurency: Int {
    case mainQueue
    case privateQueue
}

@objc
public enum FetchStatus: Int {
    case none
    case inserted
    case updated
}

@objc
public class FetchResult: NSObject, NSCopying, Describable {
    public var context: NSManagedObjectContext
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?

    private var objectID: NSManagedObjectID?

    override public required init() {
        fatalError("")
    }

    public var wotDescription: String {
        return "Context: \(context.name ?? ""); \(managedObject().entity.name ?? "<unknown>")"
    }

    public required init(context cntx: NSManagedObjectContext, objectID objID: NSManagedObjectID?, predicate predicat: NSPredicate?, fetchStatus status: FetchStatus) {
        context = cntx
        objectID = objID
        predicate = predicat
        fetchStatus = status
        super.init()
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FetchResult(context: context, objectID: objectID, predicate: predicate, fetchStatus: fetchStatus)
        return copy
    }

    public func dublicate() -> FetchResult {
        // swiftlint:disable force_cast
        return self.copy() as! FetchResult
        // swiftlint:enable force_cast
    }

    public func managedObject() -> NSManagedObject {
        return managedObject(inContext: self.context)
    }

    public func managedObject(inContext: NSManagedObjectContext) -> NSManagedObject {
        guard let objectID = objectID else {
            fatalError("objectID is not defined")
        }
        return inContext.object(with: objectID)
    }
}

public class EmptyFetchResult: FetchResult {
    public convenience required init() {
        let cntx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let objectID = NSManagedObjectID()
        self.init(context: cntx, objectID: objectID, predicate: nil, fetchStatus: .none)
    }
}
