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
    private var masterClazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, masterClazz: PrimaryKeypathProtocol.Type, pkCase: PKCase, foreignSelectKey: String, parentObjectIDList: [NSManagedObjectID]?) {
        self.json = json
        self.pkCase = pkCase
        self.foreignSelectKey = foreignSelectKey
        self.parentObjectIDList = parentObjectIDList
        self.masterClazz = masterClazz
    }

    public func build() -> LinkLookupRule? {
        guard let json = self.json else { return nil }

        let itemCase = PKCase(parentObjectIDList: parentObjectIDList)
        let objectID: Any?
        if let idKeyPath = masterClazz.primaryKeyPath(forType: .none) {
            objectID = json[idKeyPath]
        } else {
            objectID = nil
        }
        if let foreignKey = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey) {
            itemCase[.primary] = foreignKey
        }
        return LinkLookupRule(objectIdentifier: objectID, pkCase: itemCase)
    }
}
