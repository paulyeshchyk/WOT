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

    public init(inManagedObjectContext: ManagedObjectContextProtocol?) throws {
        guard let cntx = inManagedObjectContext as? NSManagedObjectContext else {
            throw EmptyFetchResultError.contextIsNotManagedObjectContext
        }
        let objectID = NSManagedObjectID()
        super.init(objectID: objectID, inContext: cntx, predicate: nil, fetchStatus: .none)
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init(objectID _: AnyObject?, inContext _: ManagedObjectContextProtocol, predicate _: NSPredicate?, fetchStatus _: FetchStatus) {
        fatalError("init(objectID:inContext:predicate:fetchStatus:) has not been implemented")
    }

    private enum EmptyFetchResultError: Error {
        case contextIsNotManagedObjectContext
    }
}
