//
//  RequestPredicateComposition.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public protocol RequestPredicateComposerProtocol: AnyObject {
    func build() -> RequestPredicateCompositionProtocol?
}

@objc
public protocol RequestPredicateCompositionProtocol: AnyObject {
    var objectIdentifier: Any? { get }
    var requestPredicate: ContextPredicate { get }
}

@objc
public class RequestPredicateComposition: NSObject, RequestPredicateCompositionProtocol {
    public let objectIdentifier: Any?
    public let requestPredicate: ContextPredicate

    required public init(objectIdentifier: Any?, requestPredicate: ContextPredicate) {
        self.objectIdentifier = objectIdentifier
        self.requestPredicate = requestPredicate
        super.init()
    }
}
