//
//  LinkedRemoteAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class LinkedRemoteAsPrimaryRuleBuilder: RequestPredicateComposerProtocol {

    private let pin: ManagedObjectLinkerPinProtocol
    private let hostObjectID: AnyObject

    // MARK: Lifecycle

    public init(pin: ManagedObjectLinkerPinProtocol, hostObjectID: AnyObject) {
        self.pin = pin
        self.hostObjectID = hostObjectID
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> RequestPredicateCompositionProtocol {
        var parentObjectIDList = [AnyObject]()
        if let parents = pin.contextPredicate?.parentObjectIDList {
            parentObjectIDList.append(contentsOf: parents)
        }
        parentObjectIDList.append(hostObjectID)

        let lookupPredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }

}
