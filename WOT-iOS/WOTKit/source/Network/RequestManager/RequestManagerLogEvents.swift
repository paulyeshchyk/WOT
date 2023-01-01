//
//  RequestManagerLogEvents.swift
//  WOTKit
//
//  Created by Paul on 1.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

final class EventRequestListenerStart: LogEventProtocol {
    public var eventType: LogEventType { return .http }
    private(set) public var message: String
    public var name: String { return "HTTPStart" }

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol) {
        message = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"
    }
}

final class EventRequestListenerCancel: LogEventProtocol {
    public var eventType: LogEventType { return .http }
    private(set) public var message: String
    public var name: String { return "HTTPCancel" }

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol, error: Error?) {
        var message: String = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"

        if let err = error {
            message += "; error:\(String(describing: err))"
        }
        self.message = message
    }
}

final class EventRequestListenerEnd: LogEventProtocol {
    public var eventType: LogEventType { return .http }
    private(set) public var message: String
    public var name: String { return "HTTPEnded" }

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol) {
        message = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"
    }
}

final class EventLongTermStart: LogEventProtocol {
    public var eventType: LogEventType { return .longTermOperation }
    private(set) public var message: String
    public var name: String { return "LongTermStart" }

    public required init?(_ text: String) {
        message = text
    }

    public init() {
        message = ""
    }
}

final class EventLongTermEnd: LogEventProtocol {
    public var eventType: LogEventType { return .longTermOperation }
    private(set) public var message: String
    public var name: String { return "LongTermEnd" }

    public required init?(_ text: String) {
        message = text
    }

    public init() {
        message = ""
    }
}

final class EventRequestManagerFetchStart: LogEventProtocol {
    public var eventType: LogEventType { return .remoteFetch }
    private(set) public var message: String
    public var name: String { return "RMStart" }

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

final class EventRequestManagerFetchCancel: LogEventProtocol {
    public var eventType: LogEventType { return .remoteFetch }
    private(set) public var message: String
    public var name: String { return "RMCancel" }

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

final class EventRequestManagerFetchEnd: LogEventProtocol {
    public var eventType: LogEventType { return .remoteFetch }
    private(set) public var message: String
    public var name: String { return "RMEnd" }

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
