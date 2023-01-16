//
//  LinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class LinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let managedRef: ManagedRefProtocol
    private let jsonRef: JSONRefProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, managedRef: ManagedRefProtocol, jsonRef: JSONRefProtocol) {
        self.pin = pin
        self.managedRef = managedRef
        self.jsonRef = jsonRef
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        var parentManagedRefs = [ManagedRefProtocol]()
        if let parents = pin.contextPredicate?.managedRefs {
            parentManagedRefs.append(contentsOf: parents)
        }
        parentManagedRefs.append(managedRef)

        var parentJsonRefs = [JSONRefProtocol]()
        if let parentJSONRef = pin.contextPredicate?.jsonRefs {
            parentJsonRefs.append(contentsOf: parentJSONRef)
        }

        let lookupPredicate = ContextPredicate(managedRefs: parentManagedRefs, jsonRefs: parentJsonRefs)
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
