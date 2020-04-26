//
//  WOTError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/26/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol WOTError: Error {}

extension Error {
    var debugDescription: String {
//        return "\(String(describing: type(of: self))).\(String(describing: self)) (code \((self as NSError).code))"
        return ".\(String(describing: self)) (code \((self as NSError).code))"
    }
}
