//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let hostManagedRef: ManagedRefProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, hostManagedRef: ManagedRefProtocol) {
        self.pin = pin
        self.hostManagedRef = hostManagedRef
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        var parentManagedRefs = [ManagedRefProtocol]()
        if let parents = pin.contextPredicate?.managedRefs {
            parentManagedRefs.append(contentsOf: parents)
        }
        parentManagedRefs.append(hostManagedRef)

        let lookupPredicate = ContextPredicate(managedRefs: parentManagedRefs)
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
