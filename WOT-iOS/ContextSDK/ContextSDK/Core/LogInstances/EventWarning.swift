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
            if details.debugDescription.count > 0 {
                messages.append(details.debugDescription)
            }
        }

        self.init(message: messages.joined(separator: "; details: "))
    }
}
