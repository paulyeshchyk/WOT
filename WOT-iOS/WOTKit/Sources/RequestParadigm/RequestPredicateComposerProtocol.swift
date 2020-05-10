//
//  LinkLookupRuleBuilderProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol RequestPredicateComposerProtocol: class {
    func build() -> RequestPredicateComposition?
}
