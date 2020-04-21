//
//  CancelLog.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class CancelLog: LogMessageTypeProtocol {
    public private(set) var message: String

    public var logeventType: String { return "CANCEL"}

    public init() {
        message = ""
    }

    required public init?(_ text: String) {
        message = text
    }
}
