//
//  MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let parentHostPin: JointPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, parentHostPin: JointPinProtocol) {
        self.pin = pin
        self.parentHostPin = parentHostPin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let pinModelClass = pin.modelClass
        let parentHostPinModelClass = parentHostPin.modelClass
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pinModelClass.primaryKey(forType: .external, andObject: pin.identifier)
        lookupPredicate[.secondary] = parentHostPinModelClass.primaryKey(forType: .internal, andObject: parentHostPin.identifier)

        return lookupPredicate
    }
}
