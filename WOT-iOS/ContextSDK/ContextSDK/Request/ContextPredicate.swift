//
//  RequestPredicate.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public class ContextPredicate: NSObject, ContextPredicateProtocol {
    /// used only when Vehicles->VehiclesProfile->ModulesTree->Module performing query for chassis, turrets, radios, engines..
    /// parents identifier has been taken from a list
    public var parentObjectIDList: [AnyObject] = []

    public convenience init(parentObjectIDList idList: [AnyObject]?) {
        self.init()

        if let compacted = idList?.compactMap({ $0 }) {
            parentObjectIDList.append(contentsOf: compacted)
        }
    }

    override public var description: String {
        let objects = expressions()
        guard !objects.isEmpty else {
            return "empty case"
        }
        var result = [String]()
        objects.forEach {
            result.append("key:`\($0.description)`")
        }
        return result.joined(separator: ";")
    }

    private var _expressions: [ContextExpressionType: Set<ContextExpression>] = .init()

    public subscript(pkType: ContextExpressionType) -> ContextExpressionProtocol? {
        get {
            return _expressions[pkType]?.first
        }
        set {
            guard let value = newValue as? ContextExpression else {
                assertionFailure("PKCase was not fully initialized")
                return
            }
            var updatedSet: Set<ContextExpression> = _expressions[pkType] ?? Set<ContextExpression>()
            updatedSet.insert(value)
            _expressions[pkType] = updatedSet
        }
    }

    public func expressions() -> Set<ContextExpression> {
        var updatedSet = Set<ContextExpression>()
        _expressions.keys.forEach {
            _expressions[$0]?.forEach { expression in
                updatedSet.insert(expression)
            }
        }
        return updatedSet
    }

    public func expressions(byType: ContextExpressionType) -> Set<ContextExpression>? {
        return _expressions[byType]
    }

    public func nspredicate(operator: ContextPredicateOperator) -> NSPredicate? {
        let predicates = expressions().compactMap { $0.predicate }
        guard !predicates.isEmpty else {
            return nil
        }
        switch `operator` {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        case .or: return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
    }
}
