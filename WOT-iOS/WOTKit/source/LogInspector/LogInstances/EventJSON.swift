//
//  EventJSON.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventJSONStart: LogEventProtocol {
    public private(set) var message: String
    public var type: LogEventType { return .json }
    public var name: String { return "JSONStart"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }
}

public class EventJSONEnded: LogEventProtocol {
    public private(set) var message: String
    public var type: LogEventType { return .json }
    public var name: String { return "JSONEnded"}

    public init() {
        message = ""
    }

    required public init?(_ text: String, initiatedIn: Date) {
        message = "\(text); elapsed: \(Date().elapsed(from: initiatedIn))"
    }
}
