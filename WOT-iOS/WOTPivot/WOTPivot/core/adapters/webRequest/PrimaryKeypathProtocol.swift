//
//  PrimaryKeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol PrimaryKeypathProtocol: class {
    static func predicateFormat() -> String
    static func predicate(for ident: AnyObject?) -> NSPredicate?
    static func primaryKeyPath() -> String
    static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey?
    static func primaryIdKeyPath() -> String // keypath for remote module search
    static func primaryIdKey(for ident: AnyObject?) -> WOTPrimaryKey?
}

@objc
public protocol WOTDescribable {
    @objc
    var description: String { get }
}

@objc
public class WOTPrimaryKey: NSObject {
    public var components: [String]
    public var value: AnyObject
    public var name: String { return components.joined(separator: ".")}
    public var nameAlias: String

    override public var description: String {
        return "\(predicate.description)"
    }

    private var predicateFormat: String = "%K = %@"

    @objc
    public required init(components: [String], value: AnyObject, nameAlias: String, predicateFormat: String) {
        self.components = components
        self.value = value as AnyObject
        self.predicateFormat = predicateFormat
        self.nameAlias = nameAlias
        super.init()
    }

    @objc
    public convenience init(name: String, value: AnyObject, nameAlias: String, predicateFormat: String) {
        self.init(components: [name], value: value, nameAlias: nameAlias, predicateFormat: predicateFormat)
    }

    @objc
    public var predicate: NSPredicate {
        return NSPredicate(format: predicateFormat, name, value as! CVarArg)
    }

    @objc
    public func foreignKey(byInsertingComponent: String) -> WOTPrimaryKey? {
        var newComponents = [byInsertingComponent]
        newComponents.append(contentsOf: self.components)
        return WOTPrimaryKey(components: newComponents, value: self.value, nameAlias: self.nameAlias, predicateFormat: predicateFormat)
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

    public override var debugDescription: String { return description }

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

public struct IntArray: Codable {
    enum CodingKeys: String, CodingKey {
        case elements
    }

    public var elements: [Int]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        elements = try container.decode([Int].self, forKey: .elements)
    }

    public subscript(index: Int) -> Int {
        get {
            return self.elements[index]
        }
        set(newValue) {
            self.elements[index] = newValue
        }
    }
}
