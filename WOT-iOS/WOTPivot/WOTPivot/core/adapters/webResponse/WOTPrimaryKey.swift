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
        set {}
        get {
            let predicateDescription = predicate.description
            let nameValue = "\(name) - \(String(describing: value))"
            return "\(nameValue): \(predicateDescription)"
        }
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
}

@objc
public class PKCase: NSObject {
    private var keys: [PKType: Set<WOTPrimaryKey>] = .init()

    public subscript(clazz: PKType) -> WOTPrimaryKey? {
        get {
            return keys[clazz]?.first
        }
        set {
            if let value = newValue {
                let key = clazz
                var updatedSet: Set<WOTPrimaryKey> = keys[key] ?? Set<WOTPrimaryKey>()
                updatedSet.insert(value)
                keys[key] = updatedSet
            }
        }
    }

    public func allValues(clazz: PKType) -> Set<WOTPrimaryKey>? {
        return keys[clazz]
    }
}
