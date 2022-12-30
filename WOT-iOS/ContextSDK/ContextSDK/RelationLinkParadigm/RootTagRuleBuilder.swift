//
//  RootTagToIDRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class RootTagRuleBuilder: RequestPredicateComposerProtocol {
    private let drivenJoint: Joint

    public init(drivenJoint: Joint, linkedClazz _: PrimaryKeypathProtocol.Type, drivenObjectID _: Any?) {
        self.drivenJoint = drivenJoint
    }

    public func build() throws -> RequestPredicateCompositionProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = drivenJoint.theClass.primaryKey(forType: .internal, andObject: drivenJoint.theID)

        return RequestPredicateComposition(objectIdentifier: drivenJoint.theID, requestPredicate: lookupPredicate)
    }
}

public enum RootTagRuleBuilderError: Error, CustomStringConvertible {
    case primaryKeyPathNotFound(PrimaryKeypathProtocol.Type)
    public var description: String {
        switch self {
        case .primaryKeyPathNotFound(let kp): return "[\(type(of: self))]: Primary keypath not found \(String(describing: kp))"
        }
    }
}
