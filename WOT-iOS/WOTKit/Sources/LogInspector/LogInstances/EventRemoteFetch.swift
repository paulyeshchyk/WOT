//
//  EventRemoteFetch.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventRemoteFetch: LogEventProtocol {
    public static var type: LogEventType { return .remoteFetch }
    public private(set) var message: String
    public var name: String { return "RemoteFetch"}

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