//
//  EventCDMerge.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/22/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventCDMerge: LogEventProtocol {
    public private(set) var message: String
    public var type: LogEventType { return .coredata }
    public var name: String { return "CDMerge"}

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
