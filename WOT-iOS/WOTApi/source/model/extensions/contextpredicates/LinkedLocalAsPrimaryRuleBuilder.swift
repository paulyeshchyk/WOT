//
//  LinkedLocalAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class LinkedLocalAsPrimaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol) {
        self.pin = pin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> FetchRequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(jsonRefs: [])
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .internal, andObject: pin.identifier)

        return FetchRequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
