//
//  JSONAdapterLogEvents.swift
//  ContextSDK
//
//  Created by Paul on 1.01.23.
//

final class EventJSONStart: LogEventProtocol {
    public var eventType: LogEventType { return .json }
    private(set) public var message: String
    public var name: String { return "JSONStart" }

    public init() {
        message = ""
    }

    public required init?(_ obj: Any) {
        message = String(describing: obj)
    }
}

final class EventJSONEnded: LogEventProtocol {
    public var eventType: LogEventType { return .json }
    private(set) public var message: String
    public var name: String { return "JSONEnded" }

    public init() {
        message = ""
    }

    public required init?(_ obj: Any, initiatedIn: Date) {
        message = "elapsed: \(Date().elapsed(from: initiatedIn)); \(String(describing: obj))"
    }
}
