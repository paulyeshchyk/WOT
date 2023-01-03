//
//  EventWarning.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

final public class EventWarning: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(message text: String) {
        message = text
    }

    public convenience init?(message: String, details: CustomDebugStringConvertible?) {
        var messages: [String] = .init()

        messages.append(message)

        if let details = details {
            if !details.debugDescription.isEmpty {
                messages.append(details.debugDescription)
            }
        }

        self.init(message: messages.joined(separator: "; details: "))
    }

    public convenience init?(error: Error?, details: Any?) {
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

    private(set) public var message: String

    public var eventType: LogEventType { return .warning }
    public var name: String { return "Warning" }
}
