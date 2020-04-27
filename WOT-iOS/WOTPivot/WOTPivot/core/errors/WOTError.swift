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
    var customDescription: String? { get }
    init(code: Int?, message: String?)
}

extension Error {
    var debugDescription: String {
        return ".\(String(describing: self)) (code \((self as NSError).code))"
    }
}
