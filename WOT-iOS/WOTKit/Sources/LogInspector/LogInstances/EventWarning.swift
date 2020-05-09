//
//  EventWarning.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventWarning: LogEventProtocol {
    public static var type: LogEventType { return .error }
    public private(set) var message: String
    public var name: String { return "!!Warning!!"}

    public init() {
        message = ""
    }

    required public init?(message text: String) {
        message = text
    }

    convenience public init?(message: String, details: Describable?) {
        var messages: [String] = .init()

        messages.append(message)

        if let details = details {
            if details.description.count > 0 {
                messages.append(details.description)
            }
        }

        self.init(message: messages.joined(separator: "; details: "))
    }
}
