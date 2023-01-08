//
//  DataStoreEmptyFetchResult.swift
//  WOTKit
//
//  Created by Paul on 19.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import CoreData

public class EmptyFetchResult: FetchResult {

    private enum EmptyFetchResultError: Error {
        case contextIsNotManagedObjectContext
    }

    // MARK: Lifecycle

    public init(inManagedObjectContext: ManagedObjectContextProtocol?) throws {
        guard let cntx = inManagedObjectContext as? NSManagedObjectContext else {
            throw EmptyFetchResultError.contextIsNotManagedObjectContext
        }
        let objectID = NSManagedObjectID()
        super.init(objectID: objectID, managedObjectContext: cntx, predicate: nil, fetchStatus: .none)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init(objectID _: AnyObject?, managedObjectContext _: ManagedObjectContextProtocol, predicate _: NSPredicate?, fetchStatus _: FetchStatus) {
        fatalError("init(objectID:managedObjectContext:predicate:fetchStatus:) has not been implemented")
    }

}
