//
//  MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private let drivenJoint: Joint
    private let hostJoint: Joint

    // MARK: Lifecycle

    public init(drivenJoint: Joint, hostJoint: Joint) {
        self.drivenJoint = drivenJoint
        self.hostJoint = hostJoint
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = drivenJoint.modelClass.primaryKey(forType: .external, andObject: drivenJoint.theID)
        lookupPredicate[.secondary] = hostJoint.modelClass.primaryKey(forType: .internal, andObject: hostJoint.theID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
