//
//  ContextPredicateProtocol.swift
//  ContextSDK
//
//  Created by Paul on 31.12.22.
//

@objc
public protocol ContextPredicateProtocol {
    var parentObjectIDList: [AnyObject] { get set }
    func expressions() -> Set<ContextExpression>
    func expressions(byType: ContextExpressionType) -> Set<ContextExpression>?
    func nspredicate(operator: ContextPredicateOperator) -> NSPredicate?
    subscript(_: ContextExpressionType) -> ContextExpressionProtocol? { get }
}

@objc
public protocol ContextPredicateContainerProtocol {
    var predicate: ContextPredicateProtocol { get }
}

@objc
public enum ContextExpressionType: NSInteger {
    case primary
    case secondary
}

@objc
public enum ContextPredicateOperator: NSInteger {
    case or
    case and
}
