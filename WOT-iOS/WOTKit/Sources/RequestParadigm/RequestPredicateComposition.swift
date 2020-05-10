//
//  RequestPredicateComposition.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class RequestPredicateComposition: NSObject {
    public let objectIdentifier: Any?
    public let requestPredicate: RequestPredicate

    required public init(objectIdentifier: Any?, requestPredicate: RequestPredicate) {
        self.objectIdentifier = objectIdentifier
        self.requestPredicate = requestPredicate
        super.init()
    }
}

