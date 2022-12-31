//
//  RequestPredicateComposition.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public class RequestPredicateComposition: NSObject, RequestPredicateCompositionProtocol {
    public let objectIdentifier: Any?
    public let contextPredicate: ContextPredicateProtocol

    override public var description: String {
        return "\(type(of: self)) predicate: [\(String(describing: contextPredicate))]; objectIdentifier: \(objectIdentifier ?? -1) "
    }

    public required init(objectIdentifier: Any?, requestPredicate: ContextPredicateProtocol) {
        self.objectIdentifier = objectIdentifier
        contextPredicate = requestPredicate
        super.init()
    }
}