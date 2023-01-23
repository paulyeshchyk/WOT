//
//  EventWEB.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventWEBStart: LogEventProtocol {
    public var eventType: LogEventType { return .web }
    public private(set) var message: String
    public var name: String { return "WEBStart" }

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol) {
        message = "\(String(describing: request))"
    }
}

public class EventWEBCancel: LogEventProtocol {
    public var eventType: LogEventType { return .web }
    public private(set) var message: String
    public var name: String { return "WEBCancel" }

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol, error: Error?) {
        var message: String = "\(String(describing: request))"
        if let err = error {
            message += "; error:\(String(describing: err))"
        }
        self.message = message
    }
}

public class EventWEBEnd: LogEventProtocol {
    public var eventType: LogEventType { return .web }
    public private(set) var message: String
    public var name: String { return "WEBEnded" }

    public init() {
        message = ""
    }

    public required init?(_ request: RequestProtocol) {
        message = "\(String(describing: request))"
    }
}
