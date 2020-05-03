//
//  FetchResult.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public typealias FetchResultCompletion = (FetchResult) -> Void

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
public class FetchResult: NSObject, NSCopying {
    public var context: NSManagedObjectContext
    private var objectID: NSManagedObjectID?
    public var fetchStatus: FetchStatus = .none
    public var predicate: NSPredicate?
    public var error: Error?

    override public required init() {
        fatalError("")
    }

    public required init(context cntx: NSManagedObjectContext, objectID objID: NSManagedObjectID?, predicate predicat: NSPredicate?, fetchStatus status: FetchStatus, error err: Error?) {
        context = cntx
        objectID = objID
        predicate = predicat
        fetchStatus = status
        error = err
        super.init()
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FetchResult(context: context, objectID: objectID, predicate: predicate, fetchStatus: fetchStatus, error: error)
        return copy
    }

    public func dublicate() -> FetchResult {
        // swiftlint:disable force_cast
        return self.copy() as! FetchResult
        // swiftlint:enable force_cast
    }

    public func managedObject() -> NSManagedObject {
        guard let objectID = objectID else {
            fatalError("objectID is not defined")
        }
        return context.object(with: objectID)
    }
}
