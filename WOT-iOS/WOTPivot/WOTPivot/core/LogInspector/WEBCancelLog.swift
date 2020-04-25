//
//  WebCancelLog.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WEBCancelLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .web }
    public var logeventType: String { return "WEBCancel"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }
}