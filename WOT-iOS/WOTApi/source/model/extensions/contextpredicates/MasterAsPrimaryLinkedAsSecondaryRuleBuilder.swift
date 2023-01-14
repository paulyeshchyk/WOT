//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let hostPin: ManagedPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, hostPin: ManagedPinProtocol) {
        self.pin = pin
        self.hostPin = hostPin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        var parentPins = [ManagedPinProtocol]()
        if let parents = pin.contextPredicate?.managedPins {
            parentPins.append(contentsOf: parents)
        }
        parentPins.append(hostPin)

        let lookupPredicate = ContextPredicate(managedPins: parentPins)
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
