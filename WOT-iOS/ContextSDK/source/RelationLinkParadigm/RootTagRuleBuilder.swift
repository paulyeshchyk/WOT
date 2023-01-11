//
//  RootTagToIDRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class RootTagRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: ManagedObjectLinkerPinProtocol

    // MARK: Lifecycle

    public init(pin: ManagedObjectLinkerPinProtocol) {
        self.pin = pin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .internal, andObject: pin.identifier)

        return RequestPredicateComposition(objectIdentifier: pin.identifier, requestPredicate: lookupPredicate)
    }

}
