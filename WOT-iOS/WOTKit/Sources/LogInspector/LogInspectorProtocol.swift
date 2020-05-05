//
//  LogInspectorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public enum LogEventType: Int {
    case error = 0
    case lifeCycle = 1
    case threads = 2
    case web = 3
    case json = 4
    case coredata = 5
    case info = 6
    case performance = 7
    case logic = 8
    case mapping = 9
    public static var allValues: [LogEventType] { [.error, .lifeCycle, .threads,.web, .json, .coredata, .info, .performance, .logic, .mapping] }
}

@objc
public protocol LogEventProtocol {
    static var type: LogEventType { get }
    var message: String { get }
    var name: String { get }
}

@objc
public protocol LogInspectorProtocol: class {
    func logEvent(_ event: LogEventProtocol?, sender: LogMessageSender?)
}

extension LogInspectorProtocol {
    func logEvent(_ event: LogEventProtocol?) { logEvent(event, sender: nil)}
}

@objc
public protocol LogMessageSender {
    var logSenderDescription: String { get }
}
