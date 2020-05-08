//
//  MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var masterClazz: PrimaryKeypathProtocol.Type
    private var masterObjectID: Any?
    private var linkedObjectID: Any

    public init(masterClazz: PrimaryKeypathProtocol.Type, masterObjectID: Any?, linkedClazz: PrimaryKeypathProtocol.Type, linkedObjectID: Any) {
        self.masterClazz = masterClazz
        self.linkedClazz = linkedClazz
        self.masterObjectID = masterObjectID
        self.linkedObjectID = linkedObjectID
    }

    public func build() -> LinkLookupRule? {
        let resultCase = PKCase()
        resultCase[.primary] = linkedClazz.primaryKey(for: linkedObjectID, andType: .remote)
        if let masterObjectID = masterObjectID {
            resultCase[.secondary] = masterClazz.primaryKey(for: masterObjectID, andType: .local)
        }

        return LinkLookupRule(objectIdentifier: nil, pkCase: resultCase)
    }
}
