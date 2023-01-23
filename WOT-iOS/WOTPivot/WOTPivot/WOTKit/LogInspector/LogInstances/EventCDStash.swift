//
//  EventCDStash.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/21/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public class EventCDStashStart: LogEventProtocol {
    public private(set) var message: String
    public var type: LogEventType { return .coredata }
    public var name: String { return "CDStashStart"}

    public init() {
        message = ""
    }

    required public init?(context: NSManagedObjectContext) {
        message = "Context: \(context.name ?? "")"
    }

    public init?(error: Error) {
        message = error.debugDescription
    }
}

public class EventCDStashEnded: LogEventProtocol {
    public private(set) var message: String
    public var type: LogEventType { return .coredata }
    public var name: String { return "CDStashEnded"}

    public init() {
        message = ""
    }

    required public init?(context: NSManagedObjectContext, initiatedIn: Date) {
        message = "Context: \(context.name ?? ""); elapsed: \(Date().elapsed(from: initiatedIn))"
    }

    public init?(error: Error) {
        message = error.debugDescription
    }
}
