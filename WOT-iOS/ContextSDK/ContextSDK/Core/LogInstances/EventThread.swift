//
//  EventThread.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventThreadCustomRun: LogEventProtocol {
    public var eventType: LogEventType { return .threads }
    public private(set) var message: String
    public var name: String { return "THREADCustom" }

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

public class EventThreadMainRun: LogEventProtocol {
    public var eventType: LogEventType { return .threads }
    public private(set) var message: String
    public var name: String { return "THREAD" }

    private static var threadMessage: String {
        let thread = Thread.current
        if let name = thread.name, name.count > 0 {
            return name
        } else {
            return thread.isMainThread ? "Main" : "thread has no name"
        }
    }

    public init() {
        message = EventThreadMainRun.threadMessage
    }

    public convenience init?(details: Any) {
        self.init()
        message += "; details: \(String(describing: details))"
    }
}
