//
//  EventObject.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - EventObjectNew

final public class EventObjectNew: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ debugDescriptable: Any) {
        message = String(describing: debugDescriptable)
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .lifeCycle }
    public var name: String { return "OBJNew" }
}

// MARK: - EventObjectFree

final public class EventObjectFree: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ debugDescriptable: Any) {
        message = String(describing: debugDescriptable)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .lifeCycle }
    public var name: String { return "OBJFree" }
}
