//
//  CreateLog.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CreateLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .normal }
    public var logeventType: String { return "NEW"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = error.localizedDescription
    }
}
