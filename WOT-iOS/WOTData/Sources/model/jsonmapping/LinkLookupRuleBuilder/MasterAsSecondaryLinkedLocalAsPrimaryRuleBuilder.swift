//
//  MasterAsSecondaryLinkedLocalAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/9/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class MasterAsSecondaryLinkedLocalAsPrimaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var linkedObjectID: AnyObject
    private var pkCase: PKCase

    public init(pkCase: PKCase, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: AnyObject) {
        self.linkedClazz = linkedClazz
        self.linkedObjectID = linkedObjectID
        self.pkCase = pkCase
    }

    public func build() -> LinkLookupRule? {
        let resultCase = PKCase()
        resultCase[.primary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .local)
        resultCase[.secondary] = pkCase[.primary]

        return LinkLookupRule(objectIdentifier: nil, pkCase: resultCase)
    }
}
