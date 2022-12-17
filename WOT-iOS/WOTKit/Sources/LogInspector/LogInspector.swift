//
//  LogInspector.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class LogInspector: NSObject, LogInspectorProtocol {
    private var prioritiesToLog: [LogEventType] = []

    public convenience init(priorities: [LogEventType]) {
        self.init()
        self.prioritiesToLog = priorities
    }

    public func logEvent(_ event: LogEventProtocol?, sender: Any?) {
        guard  let event = event else { return }
        guard isLoggable(eventClass: type(of: event)) else { return }
        let senderMessage: String
        if let sender = sender {
            senderMessage = "::\(String(describing: sender))"
        } else {
            senderMessage = ""
        }

        let eventType = event.name// ?? "UNKNOWN logeventType"
        let eventMessage = event.message// ?? ""

        print("[\(eventType)\(senderMessage)]{\(eventMessage)}")
    }

    private func isLoggable(eventClass: LogEventProtocol.Type) -> Bool {
        return prioritiesToLog.contains(eventClass.type)
    }
}
