//
//  EventCDFetch.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventCDFetchStart: LogEventProtocol {
    public static var type: LogEventType { return .coredata }
    public private(set) var message: String
    public var name: String { return "CDFetchStart"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}

public class EventCDFetchEnded: LogEventProtocol {
    public static var type: LogEventType { return .coredata }
    public private(set) var message: String
    public var name: String { return "CDFetchEnded"}

    public init() {
        message = ""
    }

    required public init?(_ text: String, initiatedIn: Date) {
        message = "\(text); elapsed: \(Date().elapsed(from: initiatedIn))"
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}
