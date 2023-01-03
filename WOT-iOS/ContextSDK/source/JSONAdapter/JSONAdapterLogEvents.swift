//
//  JSONAdapterLogEvents.swift
//  ContextSDK
//
//  Created by Paul on 1.01.23.
//

// MARK: - EventJSONStart

final class EventJSONStart: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ obj: Any) {
        message = String(describing: obj)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .json }
    public var name: String { return "JSONStart" }
}

// MARK: - EventJSONEnded

final class EventJSONEnded: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ obj: Any, initiatedIn: Date) {
        message = "elapsed: \(Date().elapsed(from: initiatedIn)); \(String(describing: obj))"
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .json }
    public var name: String { return "JSONEnded" }
}
