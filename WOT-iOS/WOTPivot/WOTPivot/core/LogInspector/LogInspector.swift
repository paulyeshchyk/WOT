//
//  LogInspector.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol LogMessageTypeProtocol {
    var message: String { get }
    var logeventType: String { get }
    init?(_ text: String)
}

@objc
public protocol LogInspectorProtocol: class {
    func log(_ type: LogMessageTypeProtocol?, sender: LogMessageSender?)
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
    public func log(_ type: LogMessageTypeProtocol?, sender: LogMessageSender?) {
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
