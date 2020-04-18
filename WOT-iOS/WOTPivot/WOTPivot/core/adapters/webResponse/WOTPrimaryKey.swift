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
    public var name: String
    public var value: AnyObject
    private var predicateFormat: String = "%K = %@"

    override public var description: String {
        set {}
        get {
            let predicateDescription = predicate.description
            let nameValue = "\(name) - \(String(describing: value))"
            return "\(nameValue): \(predicateDescription)"
        }
    }

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
