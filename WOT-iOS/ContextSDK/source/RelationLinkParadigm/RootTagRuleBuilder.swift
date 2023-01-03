//
//  RootTagToIDRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class RootTagRuleBuilder: RequestPredicateComposerProtocol {

    public init(drivenJoint: Joint) {
        self.drivenJoint = drivenJoint
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = drivenJoint.modelClass.primaryKey(forType: .internal, andObject: drivenJoint.theID)

        return RequestPredicateComposition(objectIdentifier: drivenJoint.theID, requestPredicate: lookupPredicate)
    }

    private let drivenJoint: Joint
}
