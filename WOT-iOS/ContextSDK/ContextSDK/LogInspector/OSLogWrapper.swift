//
//  OSLogWrapper.swift
//  WOTKit
//
//  Created by Paul on 18.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import OSLog

public enum LogOutputLevel: Int {
    case verbose = 4
    case debug = 3
    case info = 2
    case warning = 1
    case error = 0
}

public protocol LogContext {
    var category: String { get }
}

extension String: LogContext {
    public var category: String { self }
}

public protocol LOGOutputProtocol {
    init(consoleLevel: LogOutputLevel, bundle: Bundle)

    /// log something generally unimportant (lowest priority)
    func verbose(_ message: Any, _ file: String, _ function: String, line: Int, context: LogContext?)

    /// log something which help during debugging (low priority)
    func debug(_ message: Any, _ file: String, _ function: String, line: Int, context: LogContext?)

    /// log something which you are really interested but which is not an issue or error (normal priority)
    func info(_ message: Any, _ file: String, _ function: String, line: Int, context: LogContext?)

    /// log something which may cause big trouble soon (high priority)
    func warning(_ message: Any, _ file: String, _ function: String, line: Int, context: LogContext?)

    /// log something which will keep you awake at night (highest priority)
    func error(_ message: Any, _ file: String, _ function: String, line: Int, context: LogContext?)

    /// custom logging to manually adjust values, should just be used by other frameworks
    func custom(_ message: Any, _ file: String, _ function: String, line: Int, context: LogContext?)

    func caseNotHandled(_ file: String, _ function: String, line: Int, context: LogContext?)
}

public extension LOGOutputProtocol {
    internal init(consoleLevel: LogOutputLevel = .info, bundle: Bundle = Bundle.main) {
        self.init(consoleLevel: consoleLevel, bundle: bundle)
    }

    func verbose(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: LogContext? = nil) {
        verbose(message, file, function, line: line, context: context)
    }

    func debug(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: LogContext? = nil) {
        debug(message, file, function, line: line, context: context)
    }

    func info(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: LogContext? = nil) {
        info(message, file, function, line: line, context: context)
    }

    func warning(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: LogContext? = nil) {
        warning(message, file, function, line: line, context: context)
    }

    func error(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: LogContext? = nil) {
        error(message, file, function, line: line, context: context)
    }

    func custom(_ message: Any, _ file: String = #file, _ function: String = #function, line: Int = #line, context: LogContext? = nil) {
        custom(message, file, function, line: line, context: context)
    }

    func caseNotHandled(_ file: String = #file, _ function: String = #function, _ line: Int = #line, _ context: LogContext? = nil) {
        caseNotHandled(file, function, line: line, context: context)
    }
}

extension OSLog {
    static func log(byCategory: String, bundle: Bundle) -> OSLog? {
        guard let bundleIdentifier = bundle.bundleIdentifier else {
            return nil
        }
        return OSLog(subsystem: bundleIdentifier, category: byCategory)
    }
}

public class OSLogWrapper: LOGOutputProtocol {
    public var consoleLevel: LogOutputLevel
    public var bundle: Bundle

    public required init(consoleLevel: LogOutputLevel, bundle: Bundle) {
        self.consoleLevel = consoleLevel
        self.bundle = bundle
    }

    /// log something generally unimportant (lowest priority)
    public func verbose(_ message: Any, _: String, _: String, line _: Int, context: LogContext?) {
        guard consoleLevel.rawValue >= LogOutputLevel.verbose.rawValue,
              let message = message as? String,
              let category = context?.category,
              let log = OSLog.log(byCategory: category, bundle: bundle) else {
            return
        }
        os_log("💜 %{public}@", log: log, type: .default, message)
    }

    /// log something which help during debugging (low priority)
    public func debug(_ message: Any, _: String, _: String, line _: Int, context: LogContext?) {
        guard consoleLevel.rawValue >= LogOutputLevel.debug.rawValue,
              let message = message as? String,
              let category = context?.category,
              let log = OSLog.log(byCategory: category, bundle: bundle) else {
            return
        }
        os_log("💚 %{public}@", log: log, type: .default, message)
    }

    /// log something which you are really interested but which is not an issue or error (normal priority)
    public func info(_ message: Any, _: String, _: String, line _: Int, context: LogContext?) {
        guard consoleLevel.rawValue >= LogOutputLevel.info.rawValue,
              let message = message as? String,
              let category = context?.category,
              let log = OSLog.log(byCategory: category, bundle: bundle) else {
            return
        }
        os_log("💙 %{public}@", log: log, type: .default, message)
    }

    /// log something which may cause big trouble soon (high priority)
    public func warning(_ message: Any, _: String, _: String, line _: Int, context: LogContext?) {
        guard let message = message as? String,
              let category = context?.category,
              let log = OSLog.log(byCategory: category, bundle: bundle) else {
            return
        }
        os_log("💛 %{public}@", log: log, type: .error, message)
    }

    /// log something which will keep you awake at night (highest priority)
    public func error(_ message: Any, _: String, _: String, line _: Int, context: LogContext?) {
        guard let message = message as? String,
              let category = context?.category,
              let log = OSLog.log(byCategory: category, bundle: bundle) else {
            return
        }
        os_log("❤️ %{public}@", log: log, type: .fault, message)
    }

    /// custom logging to manually adjust values, should just be used by other frameworks
    public func custom(_ message: Any, _: String, _: String, line _: Int, context: LogContext?) {
        guard let message = message as? String,
              let category = context?.category,
              let log = OSLog.log(byCategory: category, bundle: bundle) else {
            return
        }
        os_log("🖤 %{public}@", log: log, type: .default, message)
    }

    public func caseNotHandled(_: String, _: String, line _: Int, context _: LogContext?) {}
}
