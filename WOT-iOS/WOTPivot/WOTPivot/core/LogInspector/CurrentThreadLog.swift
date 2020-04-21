//
//  CurrentThreadLog.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CurrentThreadLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .debug }
    public var logeventType: String { return "THREAD"}

    private static var threadMessage: String {
        let thread = Thread.current
        if let name = thread.name, name.count > 0 {
            return name
        } else {
            return thread.isMainThread ? "Main" : "thread has no name"
        }
    }

    public init() {
        message = CurrentThreadLog.threadMessage
    }

    public convenience init?(details: WOTDescribable) {
        self.init()
        message += "; details: \(details.description)"
    }
}
