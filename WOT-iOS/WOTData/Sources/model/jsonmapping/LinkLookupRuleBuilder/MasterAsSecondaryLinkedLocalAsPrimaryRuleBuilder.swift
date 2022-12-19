//
//  MasterAsSecondaryLinkedLocalAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/9/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

public class MasterAsSecondaryLinkedLocalAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject
    private var requestPredicate: RequestPredicate

    public init(requestPredicate: RequestPredicate, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.requestPredicate = requestPredicate
    }

    public func build() -> RequestPredicateComposition? {
        let lookupPredicate = RequestPredicate()
        lookupPredicate[.primary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .internal)
        lookupPredicate[.secondary] = requestPredicate[.primary]

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
