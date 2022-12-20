//
//  LinkedLocalAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class LinkedLocalAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject

    public init(linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
    }

    public func build() -> RequestPredicateComposition? {
        let lookupPredicate = RequestPredicate(parentObjectIDList: nil)
        lookupPredicate[.primary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .internal)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
