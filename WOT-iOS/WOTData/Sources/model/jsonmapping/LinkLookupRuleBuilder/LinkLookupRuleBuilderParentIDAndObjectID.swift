//
//  LinkLookupRuleBuilderParentIDAndObjectID.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class LinkLookupRuleBuilderParentIDAndObjectID: LinkLookupRuleBuilderProtocol {
    private var json: JSON?
    private var pkCase: PKCase
    private var foreignSelectKey: String
    private var parentObjectIDList: [NSManagedObjectID]?
    private var primaryKeyType: PrimaryKeyType
    private var clazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, pkCase: PKCase, foreignSelectKey: String, parentObjectIDList: [NSManagedObjectID]?, primaryKeyType: PrimaryKeyType, clazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.pkCase = pkCase
        self.foreignSelectKey = foreignSelectKey
        self.parentObjectIDList = parentObjectIDList
        self.primaryKeyType = primaryKeyType
        self.clazz = clazz
    }

    public func build() -> LinkLookupRule? {
        guard let json = self.json else { return nil }

        let itemCase = PKCase(parentObjectIDList: parentObjectIDList)
        let objectID: Any?
        if let idKeyPath = clazz.primaryKeyPath(forType: primaryKeyType) {
            objectID = json[idKeyPath]
        } else {
            objectID = nil
        }
        if let foreignKey = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey) {
            itemCase[.primary] = foreignKey
        }
        return LinkLookupRule(ident: objectID, pkCase: itemCase)
    }
}
