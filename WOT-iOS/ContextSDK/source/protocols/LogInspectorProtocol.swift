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
    public var description: String {
        switch self {
        case .error: return "error"
        case .warning: return "warning"
        case .info: return "info"
        case .custom: return "custom"
        case .longTermOperation: return "longTermOperation"
        // ---
        case .lifeCycle: return "lifeCycle"
        case .threads: return "threads"
        case .http: return "http"
        case .json: return "json"
        case .performance: return "performance"
        case .logic: return "logic"
        case .mapping: return "mapping"
        case .localFetch: return "localFetch"
        case .remoteFetch: return "remoteFetch"
        case .datastore: return "datastore"
        case .flow: return "flow"
        case .pivot: return "pivot"
        }
    }

    case error
    case warning
    case info
    case custom
    case longTermOperation
    // ---
    case lifeCycle
    case threads
    case http
    case json
    case performance
    case logic
    case mapping
    case localFetch
    case remoteFetch
    case datastore
    case flow
    case pivot

    public static var allValues: [LogEventType] { [.error, .lifeCycle, .threads, .http, .json, .info, .performance, .logic, .mapping, .localFetch, .remoteFetch, .flow, .longTermOperation, .datastore, .pivot, .custom] }
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
    public init(type: LoggableType, name: String, message: String) {
        self.type = type
        self.name = name
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
