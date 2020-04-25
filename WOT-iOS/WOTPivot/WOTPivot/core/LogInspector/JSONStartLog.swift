//
//  JSONStartLog.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class JSONStartLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .json }
    public var logeventType: String { return "JSONStart"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }
}
