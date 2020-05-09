//
//  WOTError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/26/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol WOTError: Error {
    var code: Int? { get }
    var message: String? { get }
    init(code: Int?, message: String?)
}

extension Error {
    public var wotDescription: String {
        if let wotError = self as? WOTError {
            let message: String = wotError.message ?? "-"
            let code: Int = wotError.code ?? -1
            return ".\(type(of: self))(code: \(code); message: \(message)"
        } else if let nserror = self as? NSError {
            return ".\(String(describing: self))(code: \(nserror.code); message: \(nserror.debugDescription)"
        } else {
            return ".\(String(describing: self))"
        }
    }
}
