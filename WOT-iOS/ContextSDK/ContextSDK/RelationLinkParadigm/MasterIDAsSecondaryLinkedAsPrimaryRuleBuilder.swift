//
//  MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var masterClazz: PrimaryKeypathProtocol.Type
    private var masterObjectID: AnyObject?
    private var linkedObjectID: AnyObject

    public init(masterClazz: PrimaryKeypathProtocol.Type, masterObjectID: AnyObject?, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject) {
        self.masterClazz = masterClazz
        self.linkedClazz = linkedClazz
        self.masterObjectID = masterObjectID
        self.linkedObjectID = linkedObjectID
    }

    public func build() -> RequestPredicateCompositionProtocol? {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = linkedClazz.primaryKey(forType: .external, andObject: linkedObjectID)
        lookupPredicate[.secondary] = masterClazz.primaryKey(forType: .internal, andObject: masterObjectID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
