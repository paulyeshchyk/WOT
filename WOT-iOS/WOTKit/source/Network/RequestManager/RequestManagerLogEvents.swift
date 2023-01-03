//
//  RequestManagerLogEvents.swift
//  WOTKit
//
//  Created by Paul on 1.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - EventRequestListenerStart

final class EventRequestListenerStart: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol) {
        message = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .http }
    public var name: String { return "HTTPStart" }
}

// MARK: - EventRequestListenerCancel

final class EventRequestListenerCancel: LogEventProtocol {

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

    private(set) public var message: String

    public var eventType: LogEventType { return .http }
    public var name: String { return "HTTPCancel" }
}

// MARK: - EventRequestListenerEnd

final class EventRequestListenerEnd: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol) {
        message = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .http }
    public var name: String { return "HTTPEnded" }
}

// MARK: - EventLongTermStart

final class EventLongTermStart: LogEventProtocol {

    public required init?(_ text: String) {
        message = text
    }

    public init() {
        message = ""
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .longTermOperation }
    public var name: String { return "LongTermStart" }
}

// MARK: - EventLongTermEnd

final class EventLongTermEnd: LogEventProtocol {

    public required init?(_ text: String) {
        message = text
    }

    public init() {
        message = ""
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .longTermOperation }
    public var name: String { return "LongTermEnd" }
}

// MARK: - EventRequestManagerFetchStart

final class EventRequestManagerFetchStart: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .remoteFetch }
    public var name: String { return "RMStart" }
}

// MARK: - EventRequestManagerFetchCancel

final class EventRequestManagerFetchCancel: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .remoteFetch }
    public var name: String { return "RMCancel" }
}

// MARK: - EventRequestManagerFetchEnd

final class EventRequestManagerFetchEnd: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .remoteFetch }
    public var name: String { return "RMEnd" }
}
