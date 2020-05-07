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
    public let ident: Any?
    public let pkCase: PKCase
    required public init(ident: Any?, pkCase: PKCase) {
        self.ident = ident
        self.pkCase = pkCase
        super.init()
    }
}

@objc
public protocol LinkLookupRuleBuilderProtocol: class {
    func build() -> LinkLookupRule?
}
