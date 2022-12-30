//
//  ForeignKeyRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class ForeignAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private var requestPredicate: ContextPredicate
    private var foreignSelectKey: String
    private var parentObjectIDList: [AnyObject]?

    public init(requestPredicate: ContextPredicate, foreignSelectKey: String, parentObjectIDList: [AnyObject]?) {
        self.requestPredicate = requestPredicate
        self.foreignSelectKey = foreignSelectKey
        self.parentObjectIDList = parentObjectIDList
    }

    public func build() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = requestPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
