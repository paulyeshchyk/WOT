//
//  EventCustomLogic.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/22/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventCustomLogic: LogEventProtocol {
    public var eventType: LogEventType { return .logic }
    public private(set) var message: String
    public var name: String { return "Logic"}

    public init() {
        message = ""
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}
