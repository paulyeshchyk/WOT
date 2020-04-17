//
//  WOTJSONLink.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTJSONLink: NSObject {
    @objc
    public var clazz: AnyClass

    @objc
    public var primaryKeys: [WOTPrimaryKey]?

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

    public init?(clazz clazzTo: AnyClass, primaryKeys keys: [WOTPrimaryKey], keypathPrefix kp: String?, completion block: @escaping (JSON) -> Void) {
        clazz = clazzTo
        primaryKeys = keys
        completion = block
        keypathPrefix = kp
        super.init()
    }
}
