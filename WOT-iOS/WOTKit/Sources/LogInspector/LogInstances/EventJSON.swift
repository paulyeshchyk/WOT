//
//  EventJSON.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class EventJSONStart: LogEventProtocol {
    public static var type: LogEventType { return .json }
    public private(set) var message: String
    public var name: String { return "JSONStart" }

    public init() {
        message = ""
    }

    public required init?(_ obj: Any) {
        message = String(describing: obj)
    }
}

public class EventJSONEnded: LogEventProtocol {
    public static var type: LogEventType { return .json }
    public private(set) var message: String
    public var name: String { return "JSONEnded" }

    public init() {
        message = ""
    }

    public required init?(_ obj: Any, initiatedIn: Date) {
        message = "elapsed: \(Date().elapsed(from: initiatedIn)); \(String(describing: obj))"
    }
}
