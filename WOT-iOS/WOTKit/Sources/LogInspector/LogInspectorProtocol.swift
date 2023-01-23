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
    case error
    case warning
    case lifeCycle
    case threads
    case web
    case json
    case coredata
    case info
    case performance
    case logic
    case mapping
    case localFetch
    case remoteFetch
    public static var allValues: [LogEventType] { [.error, .lifeCycle, .threads,.web, .json, .coredata, .info, .performance, .logic, .mapping, .localFetch, .remoteFetch] }
}

@objc
public protocol LogEventProtocol {
    static var type: LogEventType { get }
    var message: String { get }
    var name: String { get }
}

@objc
public protocol LogInspectorProtocol: AnyObject {
    func logEvent(_ event: LogEventProtocol?, sender: Any?)
}

extension LogInspectorProtocol {
    func logEvent(_ event: LogEventProtocol?) { logEvent(event, sender: nil)}
}
