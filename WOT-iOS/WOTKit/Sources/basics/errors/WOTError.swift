//
//  WOTError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/26/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol DebuggableError: Swift.Error, CustomDebugStringConvertible {
    var message: String { get }
    var code: Int { get }
}
