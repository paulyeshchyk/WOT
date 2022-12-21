//
//  BasicErrors.swift
//  ContextSDK
//
//  Created by Paul on 20.12.22.
//

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
