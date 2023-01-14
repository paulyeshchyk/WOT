//
//  MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let hostPin: JointPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, hostPin: JointPinProtocol) {
        self.pin = pin
        self.hostPin = hostPin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let pinModelClass = pin.modelClass
        let hostPinModelClass = hostPin.modelClass
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pinModelClass.primaryKey(forType: .external, andObject: pin.identifier)
        lookupPredicate[.secondary] = hostPinModelClass.primaryKey(forType: .internal, andObject: hostPin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}