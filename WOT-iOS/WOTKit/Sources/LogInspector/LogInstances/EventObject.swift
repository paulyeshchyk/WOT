//
//  EventObject.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventObjectNew: LogEventProtocol {
    public static var type: LogEventType { return .lifeCycle }
    public private(set) var message: String
    public var name: String { return "OBJNew"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = error.wotDescription
    }
}

public class EventObjectFree: LogEventProtocol {
    public static var type: LogEventType { return .lifeCycle }
    public private(set) var message: String
    public var name: String { return "OBJFree"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }
}
