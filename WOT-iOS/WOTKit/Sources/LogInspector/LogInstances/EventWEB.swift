//
//  EventWEB.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventWEBStart: LogEventProtocol {
    public static var type: LogEventType { return .web }
    public private(set) var message: String
    public var name: String { return "WEBStart" }

    public init() {
        message = ""
    }

    public required init?(_ request: WOTRequestProtocol) {
        message = "\(String(describing: request))"
    }
}

public class EventWEBCancel: LogEventProtocol {
    public static var type: LogEventType { return .web }
    public private(set) var message: String
    public var name: String { return "WEBCancel" }

    public init() {
        message = ""
    }

    public required init?(_ request: WOTRequestProtocol) {
        message = "\(String(describing: request))"
    }
}

public class EventWEBEnd: LogEventProtocol {
    public static var type: LogEventType { return .web }
    public private(set) var message: String
    public var name: String { return "WEBEnded" }

    public init() {
        message = ""
    }

    public required init?(_ request: WOTRequestProtocol) {
        message = "\(String(describing: request))"
    }
}
