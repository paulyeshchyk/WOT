//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let hostPin: AnyObject

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, hostPin: AnyObject) {
        self.pin = pin
        self.hostPin = hostPin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        var parentPins = [AnyObject]()
        if let parents = pin.contextPredicate?.pins {
            parentPins.append(contentsOf: parents)
        }
        parentPins.append(hostPin)

        let lookupPredicate = ContextPredicate(pins: parentPins)
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
