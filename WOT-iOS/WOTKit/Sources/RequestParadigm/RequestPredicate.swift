//
//  RequestPredicate.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/28/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public enum PKType: String {
    case primary
    case secondary

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}

@objc
public class RequestPredicate: NSObject {
    @objc
    public enum PredicateCompoundType: Int {
        case or = 0
        case and = 1
    }

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

    private var values: [PKType: Set<RequestExpression>] = .init()

    public subscript(pkType: PKType) -> RequestExpression? {
        get {
            return values[pkType]?.first
        }
        set {
            if let value = newValue {
                var updatedSet: Set<RequestExpression> = values[pkType] ?? Set<RequestExpression>()
                updatedSet.insert(value)
                values[pkType] = updatedSet
            } else {
                print("PKCase was not fully initialized")
            }
        }
    }

    public func allValues(_ pkType: PKType? = nil) -> Set<RequestExpression>? {
        if let pkType = pkType {
            return values[pkType]
        } else {
            var updatedSet = Set<RequestExpression>()
            values.keys.forEach {
                values[$0]?.forEach { key in
                    updatedSet.insert(key)
                }
            }
            return updatedSet
        }
    }

    public func compoundPredicate(_ byType: PredicateCompoundType = .and) -> NSPredicate? {
        let allPredicates = self.allValues()?.compactMap { $0.predicate }
        guard let predicates = allPredicates else { return nil }
        switch byType {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        case .or: return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
    }
}

extension RequestPredicate: Describable {
    public var wotDescription: String {
        guard let objects = allValues(), !objects.isEmpty else {
            return "empty case"
        }
        var result = [String]()
        objects.forEach {
            result.append("key:`\($0.description)`")
        }
        return result.joined(separator: ";")
    }
}