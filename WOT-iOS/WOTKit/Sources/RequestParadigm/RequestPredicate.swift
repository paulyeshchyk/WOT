//
//  RequestPredicate.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/28/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public enum RequestExpressionType: String {
    case primary
    case secondary
}

public enum PredicateCompoundType: Int {
    case or
    case and
}

@objc
public class RequestPredicate: NSObject {

    /// used only when Vehicles->VehiclesProfile->ModulesTree->Module performing query for chassis, turrets, radios, engines..
    /// parents identifier has been taken from a list
    public var parentObjectIDList: [NSManagedObjectID] = []

    public convenience init(parentObjectIDList idList: [NSManagedObjectID?]?) {
        self.init()

        if let compacted = idList?.compactMap({ $0 }) {
            self.parentObjectIDList.append(contentsOf: compacted)
        }
    }

    override public var debugDescription: String {
        return wotDescription
    }

    private var _expressions: [RequestExpressionType: Set<RequestExpression>] = .init()

    public subscript(pkType: RequestExpressionType) -> RequestExpression? {
        get {
            return _expressions[pkType]?.first
        }
        set {
            if let value = newValue {
                var updatedSet: Set<RequestExpression> = _expressions[pkType] ?? Set<RequestExpression>()
                updatedSet.insert(value)
                _expressions[pkType] = updatedSet
            } else {
                print("PKCase was not fully initialized")
            }
        }
    }

    public func expressions(_ pkType: RequestExpressionType? = nil) -> Set<RequestExpression>? {
        if let pkType = pkType {
            return _expressions[pkType]
        } else {
            var updatedSet = Set<RequestExpression>()
            _expressions.keys.forEach {
                _expressions[$0]?.forEach { key in
                    updatedSet.insert(key)
                }
            }
            return updatedSet
        }
    }

    public func compoundPredicate(_ byType: PredicateCompoundType) -> NSPredicate? {
        let allPredicates = expressions()?.compactMap { $0.predicate }
        guard let predicates = allPredicates else { return nil }
        switch byType {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        case .or: return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
    }
}

extension RequestPredicate: Describable {
    public var wotDescription: String {
        guard let objects = expressions(), !objects.isEmpty else {
            return "empty case"
        }
        var result = [String]()
        objects.forEach {
            result.append("key:`\($0.description)`")
        }
        return result.joined(separator: ";")
    }
}
