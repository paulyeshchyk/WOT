//
//  MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: ManagedObjectLinkerPinProtocol

    // MARK: Lifecycle

    public init(pin: ManagedObjectLinkerPinProtocol) {
        self.pin = pin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)
        lookupPredicate[.secondary] = pin.contextPredicate?[.primary]

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
