//
//  LinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class LinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    public init(drivenJoint: Joint, hostObjectID: AnyObject) {
        self.drivenJoint = drivenJoint
        self.hostObjectID = hostObjectID
    }

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        var parentObjectIDList = [AnyObject]()
        if let parents = drivenJoint.contextPredicate?.parentObjectIDList {
            parentObjectIDList.append(contentsOf: parents)
        }
        parentObjectIDList.append(hostObjectID)

        let lookupPredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = drivenJoint.modelClass.primaryKey(forType: .external, andObject: drivenJoint.theID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

    private let drivenJoint: Joint
    private let hostObjectID: AnyObject
}
