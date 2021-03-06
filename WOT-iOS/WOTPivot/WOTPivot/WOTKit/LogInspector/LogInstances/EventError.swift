//
//  EventError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventError: LogEventProtocol {
    public private(set) var message: String
    public var type: LogEventType { return .error }
    public var name: String { return "!!ERROR!!"}

    public init() {
        message = ""
    }

    required public init?(message text: String) {
        message = text
    }

    convenience public init?(_ error: Error?, details: Describable?) {
        var messages: [String] = .init()
        if let error = error {
            messages.append(error.debugDescription)
        } else {
            messages.append("Unknown error")
        }

        if let details = details {
            if details.description.count > 0 {
                messages.append(details.description)
            }
        }

        self.init(message: messages.joined(separator: "; details: "))
    }
}
