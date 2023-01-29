//
//  LinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class LinkedRemoteAsPrimaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let jsonRef: JSONRefProtocol?

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, jsonRef: JSONRefProtocol?) {
        self.pin = pin
        self.jsonRef = jsonRef
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> FetchRequestPredicateCompositionProtocol {
        var parentJsonRefs = [JSONRefProtocol]()
        if let parentJSONRef = pin.contextPredicate?.jsonRefs {
            parentJsonRefs.append(contentsOf: parentJSONRef)
        }

        let lookupPredicate = ContextPredicate(jsonRefs: parentJsonRefs)
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return FetchRequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
