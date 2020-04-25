//
//  WOTWEBRequestError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol WOTErrorProtocol {
    var wotDescription: String { get }
}

public struct WOTWEBRequestError: Error, WOTErrorProtocol {
    public enum ErrorKind {
        case dataIsNull
        case emptyJSON
        case invalidStatus
        case parseError
        case requestError(JSON?)

        var description: String {
            switch self {
            case .dataIsNull: return "dataIsNull"
            case .emptyJSON: return "emptyJSON"
            case .invalidStatus: return "invalidStatus"
            case .parseError: return "parseError"
            case .requestError(let dict):
                if let message = dict?["message"] {
                    return "requestError: \(message)"
                } else {
                    if let debugDescr = dict?.description {
                        return "requestError: \(debugDescr)"
                    } else {
                        return "requestError: unknown"
                    }
                }
            }
        }
    }

    let kind: ErrorKind
    public init(kind errorKind: ErrorKind) {
        kind = errorKind
    }

    var description: String {
        return kind.description
    }

    public var wotDescription: String {
        return kind.description
    }
}
