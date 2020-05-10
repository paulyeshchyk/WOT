//
//  LinkLookupRuleBuilderProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class LinkLookupRule: NSObject {
    public let objectIdentifier: Any?
    public let requestPredicate: RequestPredicate

    required public init(objectIdentifier: Any?, requestPredicate: RequestPredicate) {
        self.objectIdentifier = objectIdentifier
        self.requestPredicate = requestPredicate
        super.init()
    }
}

@objc
public protocol LinkLookupRuleBuilderProtocol: class {
    func build() -> LinkLookupRule?
}
