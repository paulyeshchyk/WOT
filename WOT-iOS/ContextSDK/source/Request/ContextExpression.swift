//
//  RequestExpression.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

// MARK: - ContextExpressionProtocol

@objc
public protocol ContextExpressionProtocol {
    var components: [String] { get }
    var value: JSONValueType { get }
    var name: String { get }
    var nameAlias: String { get }
    var predicate: NSPredicate { get }

    init(components: [String], value: JSONValueType, nameAlias: String, predicateFormat: String)
    init(name: String, value: JSONValueType, nameAlias: String, predicateFormat: String)

    func foreignKey(byInsertingComponent: String) -> ContextExpressionProtocol?
}

// MARK: - ContextExpression

@objc
public class ContextExpression: NSObject, ContextExpressionProtocol {

    @objc
    public required init(components: [String], value: JSONValueType, nameAlias: String, predicateFormat: String) {
        self.components = components
        self.value = value
        self.predicateFormat = predicateFormat
        self.nameAlias = nameAlias
        super.init()
    }

    @objc
    public required convenience init(name: String, value: JSONValueType, nameAlias: String, predicateFormat: String) {
        self.init(components: [name], value: value, nameAlias: nameAlias, predicateFormat: predicateFormat)
    }

    public let components: [String]
    public let value: JSONValueType
    public let nameAlias: String

    public var name: String { return components.joined(separator: ".") }
    override public var description: String {
        return "\(predicate.description)"
    }

    @objc
    public var predicate: NSPredicate {
        // swiftlint:disable force_cast
        return NSPredicate(format: predicateFormat, name, value as! CVarArg)
        // swiftlint:enable force_cast
    }

    @objc
    public func foreignKey(byInsertingComponent: String) -> ContextExpressionProtocol? {
        var newComponents = [byInsertingComponent]
        newComponents.append(contentsOf: components)
        return ContextExpression(components: newComponents, value: value, nameAlias: nameAlias, predicateFormat: predicateFormat)
    }

    private var predicateFormat: String = "%K = %@"
}
