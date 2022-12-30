//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: RequestPredicateComposerProtocol {
    private let drivenJoint: Joint
    private let hostObjectID: AnyObject

    public init(drivenJoint: Joint, hostObjectID: AnyObject) {
        self.drivenJoint = drivenJoint
        self.hostObjectID = hostObjectID
    }

    public func build() throws -> RequestPredicateCompositionProtocol {
        var parentObjectIDList = [AnyObject]()
        if let parents = drivenJoint.thePredicate?.parentObjectIDList {
            parentObjectIDList.append(contentsOf: parents)
        }
        parentObjectIDList.append(hostObjectID)

        let lookupPredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = drivenJoint.thePredicate?[.primary]
        lookupPredicate[.secondary] = drivenJoint.theClass.primaryKey(forType: .external, andObject: drivenJoint.theID)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
