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

    private(set) public var message: String

    public var eventType: LogEventType { return .http }
    public var name: String { return "HTTPStart" }

    // MARK: Lifecycle

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol) {
        message = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"
    }

}

// MARK: - EventRequestListenerCancel

final class EventRequestListenerCancel: LogEventProtocol {

    private(set) public var message: String

    public var eventType: LogEventType { return .http }
    public var name: String { return "HTTPCancel" }

    // MARK: Lifecycle

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

// MARK: - EventRequestListenerEnd

final class EventRequestListenerEnd: LogEventProtocol {

    private(set) public var message: String

    public var eventType: LogEventType { return .http }
    public var name: String { return "HTTPEnded" }

    // MARK: Lifecycle

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, listener: RequestListenerProtocol) {
        message = "Listener: \(String(describing: listener)); reacts on request: \(String(describing: request))"
    }

}
