//
//  WOTPrimaryKey.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class RequestExpression: NSObject {
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
        // swiftlint:disable force_cast
        return NSPredicate(format: predicateFormat, name, value as! CVarArg)
        // swiftlint:enable force_cast
    }

    @objc
    public func foreignKey(byInsertingComponent: String) -> RequestExpression? {
        var newComponents = [byInsertingComponent]
        newComponents.append(contentsOf: self.components)
        return RequestExpression(components: newComponents, value: self.value, nameAlias: self.nameAlias, predicateFormat: predicateFormat)
    }
}
