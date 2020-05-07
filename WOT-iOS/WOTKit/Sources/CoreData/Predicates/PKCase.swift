//
//  PKCase.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/28/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public enum PKType: Hashable {
    case primary
    case secondary
    case custom(String)
    public var identifier: String {
        switch self {
        case .primary: return "primary"
        case .secondary: return "secondary"
        case .custom(let customType): return customType
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
}

@objc
public class PKCase: NSObject {
    @objc
    public enum PredicateCompoundType: Int {
        case or = 0
        case and = 1
    }

    /**
     used only when Vehicles->VehiclesProfile->ModulesTree->Module performing query for chassis, turrets, radios, engines..
     parents identifier has taken from a list
     */
    //    @available(*, deprecated, message:"Use tree instead of plain")
    public var parentObjectIDList: [NSManagedObjectID] = []

    public convenience init(parentObjectIDList idList: [NSManagedObjectID?]?) {
        self.init()

        if let idListCompacted = idList?.compactMap({ $0 }) {
            self.parentObjectIDList.append(contentsOf: idListCompacted)
        }
    }

    override public var debugDescription: String { return description }

    private var values: [PKType: Set<WOTPrimaryKey>] = .init()

    public subscript(pkType: PKType) -> WOTPrimaryKey? {
        get {
            return values[pkType]?.first
        }
        set {
            if let value = newValue {
                var updatedSet: Set<WOTPrimaryKey> = values[pkType] ?? Set<WOTPrimaryKey>()
                updatedSet.insert(value)
                values[pkType] = updatedSet
            } else {
                print("PKCase was not fully initialized")
            }
        }
    }

    public func allValues(_ pkType: PKType? = nil) -> Set<WOTPrimaryKey>? {
        if let pkType = pkType {
            return values[pkType]
        } else {
            var updatedSet = Set<WOTPrimaryKey>()
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

extension PKCase: Describable {
    override public var description: String {
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
