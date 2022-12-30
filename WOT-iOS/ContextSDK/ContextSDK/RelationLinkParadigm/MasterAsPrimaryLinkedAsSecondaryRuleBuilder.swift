//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: RequestPredicateComposerProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject
    private var requestPredicate: ContextPredicate
    private var currentObjectID: AnyObject

    public init(requestPredicate: ContextPredicate, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject, currentObjectID: AnyObject) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.requestPredicate = requestPredicate
        self.currentObjectID = currentObjectID
    }

    public func build() throws -> RequestPredicateCompositionProtocol {
        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(currentObjectID)

        let lookupPredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = requestPredicate[.primary]
        lookupPredicate[.secondary] = linkedClazz.primaryKey(forType: .external, andObject: linkedObjectID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
