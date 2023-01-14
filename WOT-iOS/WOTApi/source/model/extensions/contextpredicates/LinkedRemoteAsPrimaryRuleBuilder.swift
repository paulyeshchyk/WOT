//
//  LinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class LinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let hostPin: AnyObject

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, hostObjectID: AnyObject) {
        self.pin = pin
        hostPin = hostObjectID
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        var parentPins = [AnyObject]()
        if let parents = pin.contextPredicate?.managedPins {
            parentPins.append(contentsOf: parents)
        }
        parentPins.append(hostPin)

        let lookupPredicate = ContextPredicate(managedPins: parentPins)
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
