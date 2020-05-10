//
//  RESTAPIError.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public struct RESTAPIError: Error, CustomStringConvertible {
    public var code: Int
    public var message: String
    public init(code: Int?, message: String?) {
        self.code = code ?? -1
        self.message = message ?? "No message"
    }

    public var description: String {
        return "RESTAPIError code: \(code); message: \(message)"
    }

    public init?(json: JSON?) {
        let code: Int = json?["code"] as? Int ?? -1
        let message = json?["message"] as? String ?? "<unknown>"

        self = RESTAPIError(code: code, message: message)
    }
}
