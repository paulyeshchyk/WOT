//
//  MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private let drivenJoint: Joint

    public init(drivenJoint: Joint) {
        self.drivenJoint = drivenJoint
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = drivenJoint.modelClass.primaryKey(forType: .external, andObject: drivenJoint.theID)
        lookupPredicate[.secondary] = drivenJoint.thePredicate?[.primary]

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
