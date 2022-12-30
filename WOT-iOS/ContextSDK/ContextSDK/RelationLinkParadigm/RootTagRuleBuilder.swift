//
//  RootTagToIDRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class RootTagRuleBuilder: RequestPredicateComposerProtocol {
    private let json: JSON
    private var linkedClazz: PrimaryKeypathProtocol.Type

    public init(json: JSON, linkedClazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.linkedClazz = linkedClazz
    }

    public func build() throws -> RequestPredicateCompositionProtocol {
        guard let idKeyPath = linkedClazz.primaryKeyPath(forType: .internal) else {
            throw RootTagRuleBuilderError.primaryKeyPathNotFound(linkedClazz)
        }
        let itemID = json[idKeyPath] as AnyObject

        let lookupPredicate = ContextPredicate()
        if let primaryID = linkedClazz.primaryKey(forType: .internal, andObject: itemID) {
            lookupPredicate[.primary] = primaryID
        }

        return RequestPredicateComposition(objectIdentifier: itemID, requestPredicate: lookupPredicate)
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
