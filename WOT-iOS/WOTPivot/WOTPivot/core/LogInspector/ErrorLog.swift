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

    public var logeventType: String { return "ERROR"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }

    convenience public init?(_ error: Error) {
        self.init(error.localizedDescription)
    }
}
