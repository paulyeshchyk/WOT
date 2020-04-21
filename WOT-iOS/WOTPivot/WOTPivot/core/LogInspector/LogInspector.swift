//
//  LogInspector.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public enum LogMessagePriorityType: Int {
    case minor = 0
    case normal = 1
    case critical = 2
    case debug = 3
}

@objc
public protocol LogMessageTypeProtocol {
    var message: String { get }
    var logeventType: String { get }
    var priorityType: LogMessagePriorityType { get }
//    init?(_ text: String)
}

@objc
public protocol LogInspectorProtocol: class {
    func log(_ type: LogMessageTypeProtocol?, sender: LogMessageSender?)

    @available(*, deprecated, message: "objC only")
    func objcOnlyAddpriority(_ priority: LogMessagePriorityType)
}

extension LogInspectorProtocol {
    func log(_ type: LogMessageTypeProtocol?) { log(type, sender: nil)}
}

@objc
public protocol LogMessageSender {
    var logSenderDescription: String { get }
}

@objc
public class LogInspector: NSObject, LogInspectorProtocol {
    private var prioritiesToLog: [LogMessagePriorityType] = []

    convenience init(priorities: [LogMessagePriorityType]) {
        self.init()
        self.prioritiesToLog = priorities
    }

    @available(*, deprecated, message: "objC only")
    @objc
    public func objcOnlyAddpriority(_ priority: LogMessagePriorityType) {
        self.prioritiesToLog.append( priority)
    }

    public func log(_ type: LogMessageTypeProtocol?, sender: LogMessageSender?) {
        if
            let eventPriority = type?.priorityType,
            prioritiesToLog.count > 0,
            !prioritiesToLog.contains(eventPriority) {
            return
        }

        let senderMessage: String
        if let logSenderDescription = sender?.logSenderDescription {
            senderMessage = "<\(logSenderDescription)>"
        } else {
            senderMessage = ""
        }

        let eventType = type?.logeventType ?? "UNKNOWN logeventType"
        let eventMessage = type?.message ?? ""

        print("[\(eventType)\(senderMessage)]{\(eventMessage)}")
    }
}
