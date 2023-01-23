//
//  LogInspector.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - LogInspector

@objc
public class LogInspector: NSObject, LogInspectorProtocol {

    public convenience init(priorities: [LogEventType]?, output: [LOGOutputProtocol]?) {
        self.init()
        self.output = output
        prioritiesToLog = priorities
    }

    public func log(_: Loggable, sander _: Any?) {
        //
    }

    public func logEvent(_ event: LogEventProtocol?, sender: Any?) {
        guard let event = event else { return }
        guard isLoggable(event) else { return }
        event.eventType.print(event: event, sender: sender, inOutputs: output)
    }

    private var prioritiesToLog: [LogEventType]?
    private var output: [LOGOutputProtocol]?

    private func isLoggable(_ event: LogEventProtocol?) -> Bool {
        guard let eventType = event?.eventType else { return false }
        guard let prioritiesToLog = prioritiesToLog else { return true }
        return prioritiesToLog.contains(eventType)
    }
}

extension LogEventType {
    func print(event: LogEventProtocol, sender: Any?, inOutputs: [LOGOutputProtocol]?) {
        let name = event.name
        let message: String
        if let sender = sender {
            message = "\(event.message); sender: <\(type(of: sender))>"
        } else {
            message = "\(event.message); sender: <unknown>"
        }
        switch self {
        case .error: inOutputs?.forEach { $0.error(message, context: name) }
        case .info: inOutputs?.forEach { $0.info(message, context: name) }
        case .warning: inOutputs?.forEach { $0.warning(message, context: name) }
        default: inOutputs?.forEach { $0.debug(message, context: name) }
        }
    }
}
