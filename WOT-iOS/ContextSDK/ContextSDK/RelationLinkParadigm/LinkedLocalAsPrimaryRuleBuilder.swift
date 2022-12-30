//
//  LinkedLocalAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class LinkedLocalAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {
    private let drivenJoint: Joint
    private let hostObjectIDList: [AnyObject]?

    public init(drivenJoint: Joint, hostObjectIDList: [AnyObject]?) {
        self.drivenJoint = drivenJoint
        self.hostObjectIDList = hostObjectIDList
    }

    public func build() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate(parentObjectIDList: hostObjectIDList)
        lookupPredicate[.primary] = drivenJoint.theClass.primaryKey(forType: .internal, andObject: drivenJoint.theID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
