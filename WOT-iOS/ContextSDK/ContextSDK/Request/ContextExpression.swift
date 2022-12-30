//
//  RequestExpression.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public class ContextExpression: NSObject {
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
    public func foreignKey(byInsertingComponent: String) -> ContextExpression? {
        var newComponents = [byInsertingComponent]
        newComponents.append(contentsOf: components)
        return ContextExpression(components: newComponents, value: value, nameAlias: nameAlias, predicateFormat: predicateFormat)
    }
}
