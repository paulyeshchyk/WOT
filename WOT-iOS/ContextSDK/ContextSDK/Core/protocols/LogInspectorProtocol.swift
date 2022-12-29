//
//  LogInspectorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 20.12.22.
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
    case flow
    case longTermOperation
    public static var allValues: [LogEventType] { [.error, .lifeCycle, .threads,.web, .json, .coredata, .info, .performance, .logic, .mapping, .localFetch, .remoteFetch, .flow, .longTermOperation] }
}

@objc
public protocol LogEventProtocol {
    var eventType: LogEventType { get }
    var message: String { get }
    var name: String { get }
}

@objc
public protocol LogInspectorContainerProtocol {
    @objc var logInspector: LogInspectorProtocol? { get set }
}

@objc
public protocol LogInspectorProtocol: AnyObject {
    func logEvent(_ event: LogEventProtocol?, sender: Any?)
}

extension LogInspectorProtocol {
    func logEvent(_ event: LogEventProtocol?) { logEvent(event, sender: nil)}
}
