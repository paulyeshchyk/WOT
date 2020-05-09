//
//  EventLocalFetch.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventLocalFetch: LogEventProtocol {
    public static var type: LogEventType { return .localFetch }
    public private(set) var message: String
    public var name: String { return "LocalFetch"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = error.debugDescription
    }
}
