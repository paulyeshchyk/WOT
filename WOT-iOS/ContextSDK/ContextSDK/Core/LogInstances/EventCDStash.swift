//
//  EventCDStash.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public class EventCDStashStart: LogEventProtocol {
    public var eventType: LogEventType { return .coredata }
    public private(set) var message: String
    public var name: String { return "CDStashStart"}

    public init() {
        message = ""
    }

    required public init?(context: ManagedObjectContextProtocol) {
        message = "Context: \(context.name ?? "")"
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}

public class EventCDStashEnded: LogEventProtocol {
    public var eventType: LogEventType { return .coredata }
    public private(set) var message: String
    public var name: String { return "CDStashEnded"}

    public init() {
        message = ""
    }

    required public init?(context: ManagedObjectContextProtocol, initiatedIn: Date) {
        message = "Context: \(context.name ?? ""); elapsed: \(Date().elapsed(from: initiatedIn))"
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}
