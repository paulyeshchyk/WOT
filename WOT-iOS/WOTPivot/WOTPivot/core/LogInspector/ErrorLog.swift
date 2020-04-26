//
//  ErrorLog.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class ErrorLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .error }
    public var logeventType: String { return "-==- ERROR -==-"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }

    convenience public init?(_ error: Any?, details: Any?) {
        var messages: [String] = .init()
        if let wotError = error as? WOTError {
            messages.append(wotError.debugDescription)
        } else if let swiftError = error as? Error {
            messages.append(swiftError.localizedDescription)
        } else {
            messages.append("Unknown error")
        }

        if let describable = details as? Describable {
            if describable.description.count > 0 {
                messages.append(describable.description)
            }
        }

        self.init(messages.joined(separator: "; details: "))
    }
}
