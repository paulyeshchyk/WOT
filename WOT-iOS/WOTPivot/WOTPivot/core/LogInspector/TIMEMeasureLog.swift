//
//  TIMEMeasureLog.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/22/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class TIMEMeasureLog: LogMessageTypeProtocol {
    public private(set) var message: String
    public var priorityType: LogMessagePriorityType { return .performance }
    public var logeventType: String { return "TIMEMeasure"}

    public init() {
        message = ""
    }

    required public init?(_ context: String, uuid: UUID) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "[HH:mm:ss.SSSS]"
        message = " \(formatter.string(from: Date())) - \(context) - \(uuid.uuidString)"
    }
}
