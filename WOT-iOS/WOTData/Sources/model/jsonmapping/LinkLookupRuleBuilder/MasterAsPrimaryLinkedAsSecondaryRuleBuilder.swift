//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: RequestPredicateComposerProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject
    private var requestPredicate: RequestPredicate
    private var parentObjectIDList: [NSManagedObjectID]?

    public init(requestPredicate: RequestPredicate, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject, parentObjectIDList: [NSManagedObjectID]?) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.requestPredicate = requestPredicate
        self.parentObjectIDList = parentObjectIDList
    }

    public func build() -> RequestPredicateComposition? {
        let lookupPredicate = RequestPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = requestPredicate[.primary]
        lookupPredicate[.secondary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .external)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
