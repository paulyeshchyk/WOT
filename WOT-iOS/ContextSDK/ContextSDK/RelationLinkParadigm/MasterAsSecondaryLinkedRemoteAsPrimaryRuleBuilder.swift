//
//  MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject
    private var requestPredicate: ContextPredicate

    public init(requestPredicate: ContextPredicate, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.requestPredicate = requestPredicate
    }

    public func build() -> RequestPredicateComposition? {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = linkedClazz.primaryKey(forType: .external, andObject: linkedObjectID)
        lookupPredicate[.secondary] = requestPredicate[.primary]

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
