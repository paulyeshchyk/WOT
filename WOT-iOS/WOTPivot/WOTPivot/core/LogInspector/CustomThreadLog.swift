//
//  CustomThreadLog.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CustomThreadLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .debug }
    public var logeventType: String { return "THREAD"}

    public init() {
        message = ""
    }

    public convenience init?(thread: Thread) {
        self.init()
        if let name = thread.name,
            name.count > 0 {
            message = name
        } else {
            message = thread.isMainThread ? "Main" : "thread has no name"
        }
    }
}
