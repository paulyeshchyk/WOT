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

    public func logEvent(_ event: LogEventProtocol?, sender: LogMessageSender?) {
        if
            let eventPriority = event?.type,
            prioritiesToLog.count > 0,
            !prioritiesToLog.contains(eventPriority) {
            return
        }

        let senderMessage: String
        if let logSenderDescription = sender?.logSenderDescription {
            senderMessage = "::\(logSenderDescription)"
        } else {
            senderMessage = ""
        }

        let eventType = event?.name ?? "UNKNOWN logeventType"
        let eventMessage = event?.message ?? ""

        print("[\(eventType)\(senderMessage)]{\(eventMessage)}")
    }
}
