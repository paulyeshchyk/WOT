//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol) {
        self.pin = pin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> FetchRequestPredicateCompositionProtocol {
        var parentJSONRefs = [JSONRefProtocol]()
        if let parentJson = pin.contextPredicate?.jsonRefs {
            parentJSONRefs.append(contentsOf: parentJson)
        }

        let lookupPredicate = ContextPredicate(jsonRefs: parentJSONRefs)
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return FetchRequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
