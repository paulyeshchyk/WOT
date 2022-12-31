//
//  EventError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventError: LogEventProtocol {
    public var eventType: LogEventType { return .error }
    public private(set) var message: String
    public var name: String { return "Error"}

    public init() {
        message = ""
    }

    public required init?(message text: String) {
        message = text
    }

    public convenience init?(_ error: Error?, details: Any?) {
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