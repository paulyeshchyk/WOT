//
//  WOTWebResponseAdapterNested.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTJSONLinksCallback = ([WOTJSONLink]?) -> Void

@objc
public class PrimaryKey: NSObject {
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

@objc
public class WOTJSONLink: NSObject {
    @objc
    public var clazz: AnyClass

    @objc
    public var primaryKeys: [PrimaryKey]?

    @objc
    public var completion: (JSON) -> Void

    @objc
    public var keypathPrefix: String?

    @objc
    public func addPreffix(to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }

    public init?(clazz clazzTo: AnyClass, primaryKeys keys: [PrimaryKey], keypathPrefix kp: String?, completion block: @escaping (JSON) -> Void) {
        clazz = clazzTo
        primaryKeys = keys
        completion = block
        keypathPrefix = kp
        super.init()
    }
}
