//
//  MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject
    private var requestPredicate: RequestPredicate

    public init(requestPredicate: RequestPredicate, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.requestPredicate = requestPredicate
    }

    public func build() -> LinkLookupRule? {
        let lookupPredicate = RequestPredicate()
        lookupPredicate[.primary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .external)
        lookupPredicate[.secondary] = requestPredicate[.primary]

        return LinkLookupRule(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}