//
//  EventObject.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class EventObjectNew: LogEventProtocol {
    public static var type: LogEventType { return .lifeCycle }
    public private(set) var message: String
    public var name: String { return "OBJNew"}

    public init() {
        message = ""
    }

    required public init?(_ debugDescriptable: Any) {
        message = String(describing: debugDescriptable)
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}

public class EventObjectFree: LogEventProtocol {
    public static var type: LogEventType { return .lifeCycle }
    public private(set) var message: String
    public var name: String { return "OBJFree"}

    public init() {
        message = ""
    }

    required public init?(_ debugDescriptable: Any) {
        message = String(describing: debugDescriptable)
    }
}
