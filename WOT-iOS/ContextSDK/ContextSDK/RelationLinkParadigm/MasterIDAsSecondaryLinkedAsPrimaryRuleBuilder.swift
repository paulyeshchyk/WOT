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

    public func build() -> RequestPredicateComposition? {
        let lookupPredicate = RequestPredicate()
        lookupPredicate[.primary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .external)
        lookupPredicate[.secondary] = masterClazz.primaryKey(for: masterObjectID, andType: .internal)
        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
