//
//  LogInspector.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

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
        guard isLoggable(event) else { return }
        guard  let event = event else { return }
        event.eventType.print(event: event, inOutputs: output)
    }

    private func isLoggable(_ event: LogEventProtocol?) -> Bool {
        guard let eventType = event?.eventType else { return false }
        guard let prioritiesToLog = prioritiesToLog else { return true }
        return prioritiesToLog.contains(eventType)
    }
}

extension LogEventType {
    func print(event: LogEventProtocol, inOutputs: [LOGOutputProtocol]?) {
        switch self {
        case .error: inOutputs?.forEach { $0.error(event.message, context: event.name) }
        case .info: inOutputs?.forEach { $0.info(event.message, context: event.name) }
        case .warning: inOutputs?.forEach { $0.warning(event.message, context: event.name) }
        case .http: inOutputs?.forEach { $0.info(event.message, context: event.name) }
        default: inOutputs?.forEach { $0.debug(event.message, context: event.name) }
        }
    }
}
