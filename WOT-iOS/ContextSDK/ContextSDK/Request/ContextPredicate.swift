//
//  RequestPredicate.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public enum RequestExpressionType: String {
    case primary
    case secondary
}

public enum PredicateCompoundType: Int {
    case or
    case and
}

public protocol ContextPredicateProtocol {
    var parentObjectIDList: [AnyObject] { get set }
    func expressions(pkType: RequestExpressionType?) -> Set<ContextExpression>?
    func compoundPredicate(_ byType: PredicateCompoundType) -> NSPredicate?
}

@objc
public protocol ContextPredicateContainerProtocol {
    var predicate: ContextPredicate { get }
}

public class ContextPredicate: NSObject, ContextPredicateProtocol {
    /// used only when Vehicles->VehiclesProfile->ModulesTree->Module performing query for chassis, turrets, radios, engines..
    /// parents identifier has been taken from a list
    public var parentObjectIDList: [AnyObject] = []

    public convenience init(parentObjectIDList idList: [AnyObject]?) {
        self.init()

        if let compacted = idList?.compactMap({ $0 }) {
            self.parentObjectIDList.append(contentsOf: compacted)
        }
    }

    override public var description: String {
        guard let objects = expressions(pkType: nil), !objects.isEmpty else {
            return "empty case"
        }
        var result = [String]()
        objects.forEach {
            result.append("key:`\($0.description)`")
        }
        return result.joined(separator: ";")
    }

    private var _expressions: [RequestExpressionType: Set<ContextExpression>] = .init()

    public subscript(pkType: RequestExpressionType) -> ContextExpression? {
        get {
            return _expressions[pkType]?.first
        }
        set {
            guard let value = newValue else {
                assertionFailure("PKCase was not fully initialized")
                return
            }
            var updatedSet: Set<ContextExpression> = _expressions[pkType] ?? Set<ContextExpression>()
            updatedSet.insert(value)
            _expressions[pkType] = updatedSet
        }
    }

    public func expressions(pkType: RequestExpressionType?) -> Set<ContextExpression>? {
        if let pkType = pkType {
            return _expressions[pkType]
        } else {
            var updatedSet = Set<ContextExpression>()
            _expressions.keys.forEach {
                _expressions[$0]?.forEach { expression in
                    updatedSet.insert(expression)
                }
            }
            return updatedSet
        }
    }

    public func compoundPredicate(_ byType: PredicateCompoundType) -> NSPredicate? {
        let allPredicates = expressions(pkType: nil)?.compactMap { $0.predicate }
        guard let predicates = allPredicates else { return nil }
        switch byType {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        case .or: return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        }
    }
}
