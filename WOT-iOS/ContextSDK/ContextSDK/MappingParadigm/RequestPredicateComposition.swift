//
//  RequestPredicateComposition.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public protocol RequestPredicateComposerProtocol: AnyObject {
    func build() -> RequestPredicateComposition?
}

@objc
public class RequestPredicateComposition: NSObject {
    public let objectIdentifier: Any?
    public let requestPredicate: ContextPredicate

    required public init(objectIdentifier: Any?, requestPredicate: ContextPredicate) {
        self.objectIdentifier = objectIdentifier
        self.requestPredicate = requestPredicate
        super.init()
    }
}
