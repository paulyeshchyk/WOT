//
//  EventTimeMeasure.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/22/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class EventTimeMeasure: LogEventProtocol {
    public static var type: LogEventType { return .performance }
    public private(set) var message: String
    public var name: String { return "TIMEMeasure"}

    public init() {
        message = ""
    }

    required public init?(_ context: String, uuid: UUID) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "[HH:mm:ss.SSSS]"
        message = " \(formatter.string(from: Date())) - \(context) - \(uuid.uuidString)"
    }
}
