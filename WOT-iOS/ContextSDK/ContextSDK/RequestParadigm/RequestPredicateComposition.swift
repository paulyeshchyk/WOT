//
//  RequestPredicateComposition.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public class RequestPredicateComposition: NSObject, RequestPredicateCompositionProtocol {
    public let objectIdentifier: Any?
    public let requestPredicate: ContextPredicate

    override public var description: String {
        return "\(type(of: self)) predicate: [\(String(describing: requestPredicate))]; objectIdentifier: \(objectIdentifier ?? -1) "
    }

    public required init(objectIdentifier: Any?, requestPredicate: ContextPredicate) {
        self.objectIdentifier = objectIdentifier
        self.requestPredicate = requestPredicate
        super.init()
    }
}
