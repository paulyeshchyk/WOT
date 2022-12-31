//
//  EventWEB.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventRequestListenerStart: LogEventProtocol {
    public var eventType: LogEventType { return .http }
    public private(set) var message: String
    public var name: String { return "HTTPStart" }

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol) {
        message = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"
    }
}

public class EventRequestListenerCancel: LogEventProtocol {
    public var eventType: LogEventType { return .http }
    public private(set) var message: String
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

public class EventRequestListenerEnd: LogEventProtocol {
    public var eventType: LogEventType { return .http }
    public private(set) var message: String
    public var name: String { return "HTTPEnded" }

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol) {
        message = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"
    }
}

public class EventLongTermStart: LogEventProtocol {
    public var eventType: LogEventType { return .longTermOperation }
    public private(set) var message: String
    public var name: String { return "LongTermStart" }

    public required init?(_ text: String) {
        message = text
    }

    public init() {
        message = ""
    }
}

public class EventLongTermEnd: LogEventProtocol {
    public var eventType: LogEventType { return .longTermOperation }
    public private(set) var message: String
    public var name: String { return "LongTermEnd" }

    public required init?(_ text: String) {
        message = text
    }

    public init() {
        message = ""
    }
}

public class EventRequestManagerFetchStart: LogEventProtocol {
    public var eventType: LogEventType { return .remoteFetch }
    public private(set) var message: String
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

public class EventRequestManagerFetchCancel: LogEventProtocol {
    public var eventType: LogEventType { return .remoteFetch }
    public private(set) var message: String
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

public class EventRequestManagerFetchEnd: LogEventProtocol {
    public var eventType: LogEventType { return .remoteFetch }
    public private(set) var message: String
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
