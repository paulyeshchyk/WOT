//
//  CDMapping.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/29/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CDMappingStartLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .mapping }
    public var logeventType: String { return "CDMappingStart"}

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

public class CDMappingEndLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .mapping }
    public var logeventType: String { return "CDMappingEnded"}

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
