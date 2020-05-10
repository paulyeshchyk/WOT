//
//  LogicError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/28/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public enum LogicError: Error {
    case shouldBeOverriden(String)
    case objectNotDefined
    case wrongUnwrapping
    public var debugDescription: String {
        switch self {
        case .shouldBeOverriden(let txt): return "'\(txt)' should be overridden"
        case .objectNotDefined: return "Object is not defined"
        case .wrongUnwrapping: return "Received response from released request"
        }
    }
}
