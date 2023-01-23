//
//  EmptyFetchResult.swift
//  WOTKit
//
//  Created by Paul on 19.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public class EmptyFetchResult: FetchResult {
    public required convenience init() {
        let cntx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let objectID = NSManagedObjectID()
        self.init(objectContext: cntx, objectID: objectID, predicate: nil, fetchStatus: .none)
    }
}
