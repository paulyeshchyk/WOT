//
//  EventObject.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventObjectNew: LogEventProtocol {
    public var eventType: LogEventType { return .lifeCycle }
    public private(set) var message: String
    public var name: String { return "OBJNew"}

    public init() {
        message = ""
    }

    public required init?(_ debugDescriptable: Any) {
        message = String(describing: debugDescriptable)
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}

public class EventObjectFree: LogEventProtocol {
    public var eventType: LogEventType { return .lifeCycle }
    public private(set) var message: String
    public var name: String { return "OBJFree"}

    public init() {
        message = ""
    }

    public required init?(_ debugDescriptable: Any) {
        message = String(describing: debugDescriptable)
    }
}
