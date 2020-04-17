//
//  PrimaryKey.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTPrimaryKey: NSObject {
    var name: String
    var value: AnyObject
    private var predicateFormat: String = "%K = %@"

    @objc
    public required init(name: String, value: AnyObject, predicateFormat: String) {
        self.name = name
        self.value = value as AnyObject
        self.predicateFormat = predicateFormat
        super.init()
    }

    @objc
    public var predicate: NSPredicate {
        return NSPredicate(format: predicateFormat, name, value as! CVarArg)
    }
}
