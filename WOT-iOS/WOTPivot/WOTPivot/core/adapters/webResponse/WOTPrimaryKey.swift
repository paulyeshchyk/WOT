//
//  PrimaryKey.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTPrimaryKey: NSObject {
    public var components: [String]
    public var value: AnyObject
    public var name: String { return components.joined(separator: ".")}

    override public var description: String {
        return "\(predicate.description)"
    }

    private var predicateFormat: String = "%K = %@"

    @objc
    public required init(components: [String], value: AnyObject, predicateFormat: String) {
        self.components = components
        self.value = value as AnyObject
        self.predicateFormat = predicateFormat
        super.init()
    }

    @objc
    public convenience init(name: String, value: AnyObject, predicateFormat: String) {
        self.init(components: [name], value: value, predicateFormat: predicateFormat)
    }

    @objc
    public var predicate: NSPredicate {
        return NSPredicate(format: predicateFormat, name, value as! CVarArg)
    }

    @objc
    public func foreignKey(byInsertingComponent: String) -> WOTPrimaryKey? {
        var newComponents = [byInsertingComponent]
        newComponents.append(contentsOf: self.components)
        return WOTPrimaryKey(components: newComponents, value: self.value, predicateFormat: predicateFormat)
    }
}

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
public class PKCase: NSObject, WOTDescribable {
    @objc
    public enum PredicateCompoundType: Int {
        case or = 0
        case and = 1
    }

    public override var description: String {
        guard let objects = allValues(), !objects.isEmpty else {
            return "empty case"
        }
        var result = [String]()
        objects.forEach {
            result.append("key:`\($0.description)`")
        }
        return result.joined(separator: ";")
    }

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
            }
        }
    }

    public func allValues(_ pkType: PKType? = nil) -> Set<WOTPrimaryKey>? {
        if let pkType = pkType {
            return values[pkType]
        } else {
            var updatedSet = Set<WOTPrimaryKey>()
            values.keys.forEach {
                values[$0]?.forEach({ key in
                    updatedSet.insert(key)
                })
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
