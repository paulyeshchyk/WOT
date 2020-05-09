//
//  ForeignAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class ForeignAsPrimaryLinkedAsSecondaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var pkCase: PKCase
    private var ammoType: AnyObject?
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var foreignSelectKey: String

    public init(pkCase: PKCase, ammoType: AnyObject?, linkedClazz: PrimaryKeypathProtocol.Type, foreignSelectKey: String) {
        self.pkCase = pkCase
        self.linkedClazz = linkedClazz
        self.foreignSelectKey = foreignSelectKey
        self.ammoType = ammoType
    }

    public func build() -> LinkLookupRule? {
        let vehicleprofileAmmoCase = PKCase()
        vehicleprofileAmmoCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)
        vehicleprofileAmmoCase[.secondary] = linkedClazz.primaryKey(for: ammoType, andType: .internal)

        return LinkLookupRule(objectIdentifier: nil, pkCase: vehicleprofileAmmoCase)
    }
}
