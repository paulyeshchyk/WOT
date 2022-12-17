//
//  LinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class LinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject?
    private var requestPredicate: RequestPredicate
    private var currentObjectID: NSManagedObjectID

    public init(requestPredicate: RequestPredicate, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject?, currentObjectID: NSManagedObjectID) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.requestPredicate = requestPredicate
        self.currentObjectID = currentObjectID
    }

    public func build() -> RequestPredicateComposition? {
        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(currentObjectID)
        let lookupPredicate = RequestPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = linkedClazz.primaryKey(for: linkedObjectID as AnyObject, andType: .external)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
