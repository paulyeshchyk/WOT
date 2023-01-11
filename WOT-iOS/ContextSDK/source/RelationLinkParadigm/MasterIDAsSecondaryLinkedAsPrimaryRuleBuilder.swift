//
//  MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: ManagedObjectLinkerPinProtocol
    private let hostPin: ManagedObjectLinkerPinProtocol

    // MARK: Lifecycle

    public init(pin: ManagedObjectLinkerPinProtocol, hostPin: ManagedObjectLinkerPinProtocol) {
        self.pin = pin
        self.hostPin = hostPin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)
        lookupPredicate[.secondary] = hostPin.modelClass.primaryKey(forType: .internal, andObject: hostPin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
