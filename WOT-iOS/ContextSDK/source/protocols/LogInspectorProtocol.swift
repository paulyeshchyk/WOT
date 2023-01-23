//
//  LogInspectorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 20.12.22.
//

import Foundation

// MARK: - LogEventType

@objc
public enum LogEventType: Int, CustomStringConvertible {
    case error
    case warning
    case info
    case custom
    case sqlite
    case performance
    // ---
    case lifeCycle
    case http
    case json
    case logic
    case mapping
    case remoteFetch
    case flow

    public static var allValues: [LogEventType] { [.error, .lifeCycle, .http, .json, .info, .performance, .logic, .mapping, .sqlite, .remoteFetch, .flow, .custom] }

    public var description: String {
        switch self {
        case .error: return "error"
        case .warning: return "warning"
        case .info: return "info"
        case .custom: return "custom"
        case .performance: return "performance"
        case .sqlite: return "sqlite"
        // ---
        case .lifeCycle: return "lifeCycle"
        case .http: return "http"
        case .json: return "json"
        case .logic: return "logic"
        case .mapping: return "mapping"
        case .remoteFetch: return "web"
        case .flow: return "flow"
        }
    }

}

// MARK: - LogEventProtocol

@objc
public protocol LogEventProtocol {
    var eventType: LogEventType { get }
    var message: String { get }
    var name: String { get }
}

// MARK: - LogInspectorContainerProtocol

@objc
public protocol LogInspectorContainerProtocol {
    @objc var logInspector: LogInspectorProtocol? { get set }
}

// MARK: - Loggable

public class Loggable {
    var name: String
    var type: LoggableType
    var message: String

    // MARK: Lifecycle

    public init(type: LoggableType, name: String, message: String) {
        self.type = type
        self.name = name.rightJustified(width: 10, truncate: true, spacer: " ")
        self.message = message
    }

    public convenience init(type: LoggableType, message: String) {
        let convertedName = String(describing: type)
        self.init(type: type, name: convertedName, message: message)
    }

}

// MARK: - LogInspectorProtocol

@objc
public protocol LogInspectorProtocol: AnyObject {
    func logEvent(_ event: LogEventProtocol?, sender: Any?)
}

extension LogInspectorProtocol {
    func logEvent(_ event: LogEventProtocol?) { logEvent(event, sender: nil) }
}
