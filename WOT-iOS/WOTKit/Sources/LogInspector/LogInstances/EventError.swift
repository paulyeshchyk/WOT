//
//  EventError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventError: LogEventProtocol {
    public static var type: LogEventType { return .error }
    public private(set) var message: String
    public var name: String { return "!!ERROR!!"}

    public init() {
        message = ""
    }

    required public init?(message text: String) {
        message = text
    }

    convenience public init?(_ error: Error?, details: Any?) {
        var messages: [String] = .init()
        if let error = error {
            messages.append(String(describing: error))
        } else {
            messages.append("Unknown error")
        }

        if let details = details {
            let txt = String(describing: details)
            messages.append(txt)
        }

        self.init(message: messages.joined(separator: "; details: "))
    }
}
