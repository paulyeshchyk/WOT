//
//  LinkedLocalAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class LinkedLocalAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private let drivenJoint: Joint

    public init(drivenJoint: Joint) {
        self.drivenJoint = drivenJoint
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(parentObjectIDList: nil)
        lookupPredicate[.primary] = drivenJoint.theClass.primaryKey(forType: .internal, andObject: drivenJoint.theID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
