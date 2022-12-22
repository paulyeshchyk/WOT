//
//  EventTimeMeasure.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/22/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventTimeMeasure: LogEventProtocol {
    public var eventType: LogEventType { return .performance }
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
