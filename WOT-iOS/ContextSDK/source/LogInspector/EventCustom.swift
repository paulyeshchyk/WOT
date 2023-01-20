//
//  EventCustom.swift
//  ContextSDK
//
//  Created by Paul on 4.01.23.
//

extension LogInspectorProtocol {
    public func log(_ loggable: Loggable, sender: Any?) {
        let event = EventCustom(loggable)
        logEvent(event, sender: sender)
    }
}

// MARK: - EventCustom

public class EventCustom: LogEventProtocol {

    public var message: String
    public var eventType: LogEventType
    public var name: String

    // MARK: Lifecycle

    public required init(_ loggable: Loggable) {
        message = loggable.message
        eventType = loggable.type.type
        name = loggable.name
    }
}

// MARK: - LoggableType

public struct LoggableType: CustomStringConvertible {
    public var name: String
    public var type: LogEventType

    public var description: String { return name }

    // MARK: Lifecycle

    init(name: String, type: LogEventType) {
        self.name = name
        self.type = type
    }

    init(type: LogEventType) {
        let convertedName = String(describing: type)
        self.init(name: convertedName, type: type)
    }
}

// MARK: - LogsDefault

extension LoggableType {
    static let info = LoggableType(type: .info)
    static let error = LoggableType(type: .error)
    static let lifecycle = LoggableType(type: .lifeCycle)
    static let warning = LoggableType(type: .warning)
    static let custom = LoggableType(type: .custom)
    static let flow = LoggableType(type: .flow)
    static let performance = LoggableType(type: .performance)
    static let sqlite = LoggableType(type: .sqlite)
    static let remoteFetch = LoggableType(type: .remoteFetch)
}

extension Loggable {

    private enum LoggableError: Error, CustomStringConvertible {
        case notAnError

        var description: String {
            switch self {
            case .notAnError: return "Error is nil, but was logged"
            }
        }
    }

    public static func info(name: String, message: String) -> Loggable {
        Loggable(type: .info, name: name, message: message)
    }

    public static func info(_ message: String) -> Loggable {
        Loggable(type: .info, message: message)
    }

    public static func error(_ message: String) -> Loggable {
        Loggable(type: .error, message: message)
    }

    public static func error(_ error: Error?) -> Loggable {
        Loggable(type: .error, message: String(describing: error ?? LoggableError.notAnError))
    }

    public static func warning(error: Error?) -> Loggable {
        Loggable(type: .warning, message: String(describing: error ?? LoggableError.notAnError))
    }

    public static func warning(_ message: String) -> Loggable {
        Loggable(type: .warning, message: message)
    }

    public static func initialization(_ subject: AnyClass) -> Loggable {
        Loggable(type: .lifecycle, name: "init", message: String(describing: subject))
    }

    public static func destruction(_ subject: AnyClass) -> Loggable {
        Loggable(type: .lifecycle, name: "deinit", message: String(describing: subject))
    }

    public static func custom(name: String, message: String) -> Loggable {
        Loggable(type: .custom, name: name, message: message)
    }

    public static func custom(_ message: String) -> Loggable {
        Loggable(type: .custom, message: message)
    }

    public static func flow(name: String, message: String) -> Loggable {
        Loggable(type: .flow, name: name, message: message)
    }

    public static func performance(name: String, message: String) -> Loggable {
        Loggable(type: .performance, name: name, message: message)
    }

    public static func sqlite(name: String, message: String) -> Loggable {
        Loggable(type: .sqlite, name: name, message: message)
    }

    public static func sqlite(message: String) -> Loggable {
        Loggable(type: .sqlite, message: message)
    }

    public static func remoteFetch(message: String) -> Loggable {
        Loggable(type: .remoteFetch, message: message)
    }

    public static func mapping(name: String, fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol) -> Loggable {
        let message = "\(name) Mapping \(String(describing: fetchResult)) \(String(describing: predicate))"
        return Loggable(type: .flow, message: message)
    }
}
