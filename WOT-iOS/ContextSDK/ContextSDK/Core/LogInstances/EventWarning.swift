//
//  EventWarning.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventWarning: LogEventProtocol {
    public var eventType: LogEventType { return .warning }
    public private(set) var message: String
    public var name: String { return "Warning"}

    public init() {
        message = ""
    }

    required public init?(message text: String) {
        message = text
    }

    convenience public init?(message: String, details: CustomDebugStringConvertible?) {
        var messages: [String] = .init()

        messages.append(message)

        if let details = details {
            if !details.debugDescription.isEmpty {
                messages.append(details.debugDescription)
            }
        }

        self.init(message: messages.joined(separator: "; details: "))
    }

    convenience public init?(error: Error?, details: Any?) {
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
