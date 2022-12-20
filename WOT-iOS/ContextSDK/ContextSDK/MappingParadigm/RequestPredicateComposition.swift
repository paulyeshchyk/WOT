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

public class RequestPredicateComposition: NSObject {
    public let objectIdentifier: Any?
    public let requestPredicate: RequestPredicate

    required public init(objectIdentifier: Any?, requestPredicate: RequestPredicate) {
        self.objectIdentifier = objectIdentifier
        self.requestPredicate = requestPredicate
        super.init()
    }
}
