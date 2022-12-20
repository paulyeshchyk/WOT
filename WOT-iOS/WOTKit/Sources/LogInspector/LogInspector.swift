//
//  LogInspector.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public class LogInspector: NSObject, LogInspectorProtocol {
    private var prioritiesToLog: [LogEventType]?
    private var output: [LOGOutputProtocol]?

    public convenience init(priorities: [LogEventType]?, output: [LOGOutputProtocol]?) {
        self.init()
        self.output = output
        self.prioritiesToLog = priorities
    }

    public func logEvent(_ event: LogEventProtocol?, sender: Any?) {
        guard  let event = event else { return }
        guard isLoggable(eventClass: type(of: event)) else { return }
        switch type(of: event).type {
        case .error:
            output?.forEach { $0.error(event.message, context: event.name) }
        case .info:
            output?.forEach { $0.info(event.message, context: event.name) }
        case .warning:
            output?.forEach { $0.warning(event.message, context: event.name) }
        case .web:
            output?.forEach { $0.info(event.message, context: event.name) }
        default:
            output?.forEach { $0.debug(event.message, context: event.name) }
        }
    }

    private func isLoggable(eventClass: LogEventProtocol.Type) -> Bool {
        guard let prioritiesToLog = prioritiesToLog else { return true }
        return prioritiesToLog.contains(eventClass.type)
    }
}
