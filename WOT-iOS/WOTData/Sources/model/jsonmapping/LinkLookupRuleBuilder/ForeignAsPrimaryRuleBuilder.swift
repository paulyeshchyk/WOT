//
//  ForeignKeyRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class ForeignAsPrimaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var pkCase: PKCase
    private var foreignSelectKey: String
    private var parentObjectIDList: [NSManagedObjectID]?

    public init(pkCase: PKCase, foreignSelectKey: String, parentObjectIDList: [NSManagedObjectID]?) {
        self.pkCase = pkCase
        self.foreignSelectKey = foreignSelectKey
        self.parentObjectIDList = parentObjectIDList
    }

    public func build() -> LinkLookupRule? {
        let itemCase = PKCase(parentObjectIDList: parentObjectIDList)

        if let foreignKey = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey) {
            itemCase[.primary] = foreignKey
        }
        return LinkLookupRule(objectIdentifier: nil, pkCase: itemCase)
    }
}
