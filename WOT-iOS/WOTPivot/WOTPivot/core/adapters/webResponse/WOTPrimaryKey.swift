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

public typealias PKCase = Dictionary<AnyHashable, [WOTPrimaryKey]>

@objc
public class PKCase2: NSObject {
    private var keys: [String: Set<WOTPrimaryKey>] = .init()

    public subscript(clazz: AnyClass) -> WOTPrimaryKey? {
        get {
            return keys[String(describing: clazz)]?.first
        }
        set {
            if let value = newValue {
                let key = String(describing: clazz)
                var updatedSet: Set<WOTPrimaryKey> = keys[key] ?? Set<WOTPrimaryKey>()
                updatedSet.insert(value)
                keys[key] = updatedSet
            }
        }
    }

    public func allValues(clazz: AnyClass) -> Set<WOTPrimaryKey>? {
        return keys[String(describing: clazz)]
    }
}
