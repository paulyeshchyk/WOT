//
//  WOTJSONLink.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias JSONCompletion = (JSON) -> Void

@objc
public class WOTJSONLink: NSObject {
    @objc
    public var clazz: AnyClass

    @objc
    public var primaryKeys: [WOTPrimaryKey] {
        return pkCase?.allValues()?.compactMap { $0 } ?? []
    }

    @objc
    public var pkCase: PKCase?

    @objc
    public var completion: JSONCompletion?

    @objc
    public var keypathPrefix: String?

    public override var description: String {
        get {
            var result: String = "WOTJSONLink: \(String(describing: clazz))"
            primaryKeys.forEach {
                result += " key:\($0)"
            }
            if let prefix = keypathPrefix {
                result += " prefix:\(prefix)"
            }
            return result
        }
        set {}
    }

    @objc
    public func addPreffix(to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }

    public init?(clazz clazzTo: AnyClass, pkCase parentCase: PKCase, keypathPrefix kp: String?, completion block: JSONCompletion?) {
        clazz = clazzTo
        pkCase = parentCase
        completion = block
        keypathPrefix = kp
        super.init()
    }
}
