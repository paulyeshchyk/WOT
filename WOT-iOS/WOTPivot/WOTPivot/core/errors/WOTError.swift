//
//  WOTError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/26/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol DebugDescriptable {
    var debugDescription: String { get }
}

public protocol WOTError: Error, DebugDescriptable {
    var code: Int? { get }
    var message: String? { get }
    init(code: Int?, message: String?)
}

extension Error {
    public var debugDescription: String {
        return ".\(String(describing: self)) (code \((self as NSError).code))"
    }
}
