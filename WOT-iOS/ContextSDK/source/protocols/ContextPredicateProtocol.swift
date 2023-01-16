//
//  ContextPredicateProtocol.swift
//  ContextSDK
//
//  Created by Paul on 31.12.22.
//

// MARK: - ContextPredicateProtocol

@objc
public protocol ContextPredicateProtocol {
    //
    @available(*, deprecated)
    var managedRefs: [ManagedRefProtocol] { get set }
    var jsonRefs: [JSONRefProtocol] { get set }

    func expressions() -> Set<ContextExpression>
    func expressions(byType: ContextExpressionType) -> Set<ContextExpression>?
    func nspredicate(operator: ContextPredicateOperator) -> NSPredicate?
    subscript(_: ContextExpressionType) -> ContextExpressionProtocol? { get }
}

// MARK: - ContextPredicateContainerProtocol

@objc
public protocol ContextPredicateContainerProtocol {
    var contextPredicate: ContextPredicateProtocol { get }
}

// MARK: - ContextExpressionType

@objc
public enum ContextExpressionType: NSInteger {
    case primary
    case secondary
}

// MARK: - ContextPredicateOperator

@objc
public enum ContextPredicateOperator: NSInteger {
    case or
    case and
}
