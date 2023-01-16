//
//  ForeignKeyRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class ForeignAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private var foreignSelectKey: String
    private let jsonRefs: [JSONRefProtocol]
    private let jsonMap: JSONMapProtocol

    // MARK: Lifecycle

    public init(jsonMap: JSONMapProtocol, foreignSelectKey: String, jsonRefs: [JSONRefProtocol]) {
        self.foreignSelectKey = foreignSelectKey
        self.jsonRefs = jsonRefs
        self.jsonMap = jsonMap
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(jsonRefs: jsonRefs)
        lookupPredicate[.primary] = jsonMap.contextPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
