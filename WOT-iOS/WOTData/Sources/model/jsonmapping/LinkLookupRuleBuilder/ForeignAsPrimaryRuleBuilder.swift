//
//  ForeignKeyRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class ForeignAsPrimaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var requestPredicate: RequestPredicate
    private var foreignSelectKey: String
    private var parentObjectIDList: [NSManagedObjectID]?

    public init(requestPredicate: RequestPredicate, foreignSelectKey: String, parentObjectIDList: [NSManagedObjectID]?) {
        self.requestPredicate = requestPredicate
        self.foreignSelectKey = foreignSelectKey
        self.parentObjectIDList = parentObjectIDList
    }

    public func build() -> LinkLookupRule? {
        let lookupPredicate = RequestPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = requestPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)

        return LinkLookupRule(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
