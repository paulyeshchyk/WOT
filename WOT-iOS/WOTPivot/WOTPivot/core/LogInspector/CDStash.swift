//
//  CDStash.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CDStashLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .coredata }
    public var logeventType: String { return "CDStash"}

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
