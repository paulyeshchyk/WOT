//
//  WOTJSONPredicate.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class RequestPredicate: NSObject {
    //
    public var clazz: AnyClass

    public var primaryKeys: [WOTPrimaryKey] {
        return pkCase?.allValues()?.compactMap { $0 } ?? []
    }

    public var pkCase: PKCase?

    public var keypathPrefix: String?

    public func addPreffix(to: String) -> String {
        guard let preffix = keypathPrefix else {
            return to
        }
        return String(format: "%@%@", preffix, to)
    }

    public init(clazz clazzTo: AnyClass, pkCase parentCase: PKCase, keypathPrefix kp: String?) {
        clazz = clazzTo
        pkCase = parentCase
        keypathPrefix = kp
    }
}

extension RequestPredicate: Describable {
    public var wotDescription: String {
        var result: String = "RequestArguments: \(String(describing: clazz))"
        primaryKeys.forEach {
            result += " key:\($0)"
        }
        if let prefix = keypathPrefix {
            result += " prefix:\(prefix)"
        }
        return result
    }
}

extension RequestPredicate {
    public func buildRequestArguments() -> WOTRequestArguments {
        let keyPaths = self.clazz.classKeypaths().compactMap {
            self.addPreffix(to: $0)
        }

        let arguments = WOTRequestArguments()
        #warning("forKey: fields should be refactored")
        arguments.setValues(keyPaths, forKey: "fields")
        self.primaryKeys.forEach {
            arguments.setValues([$0.value], forKey: $0.nameAlias)
        }
        return arguments
    }
}
