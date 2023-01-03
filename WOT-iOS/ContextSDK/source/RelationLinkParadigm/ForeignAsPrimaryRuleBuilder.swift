//
//  ForeignKeyRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class ForeignAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    public init(requestPredicate: ContextPredicateProtocol, foreignSelectKey: String, parentObjectIDList: [AnyObject]?) {
        self.requestPredicate = requestPredicate
        self.foreignSelectKey = foreignSelectKey
        self.parentObjectIDList = parentObjectIDList
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = requestPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

    private var requestPredicate: ContextPredicateProtocol
    private var foreignSelectKey: String
    private var parentObjectIDList: [AnyObject]?
}
