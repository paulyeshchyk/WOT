//
//  MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private let drivenJoint: Joint

    // MARK: Lifecycle

    public init(drivenJoint: Joint) {
        self.drivenJoint = drivenJoint
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = drivenJoint.modelClass.primaryKey(forType: .external, andObject: drivenJoint.theID)
        lookupPredicate[.secondary] = drivenJoint.contextPredicate?[.primary]

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
