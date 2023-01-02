//
//  DatastoreLogEvents.swift
//  ContextSDK
//
//  Created by Paul on 1.01.23.
//

final public class EvenDatastoreWillSave: LogEventProtocol {
    public var eventType: LogEventType { return .datastore }
    private(set) public var message: String
    public var name: String { return "CDStashStart"}

    public init(uuid: UUID, description: String) {
        message = "\(description), operation <\(uuid.MD5)>"
    }
}

final public class EvenDatastoreDidSave: LogEventProtocol {
    public var eventType: LogEventType { return .datastore }
    private(set) public var message: String
    public var name: String { return "CDStashEnded"}

    public init(uuid: UUID, initiatedIn: Date, description: String) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "[HH:mm:ss.SSSS]"
        message = "\(description), operation <\(uuid.MD5)>: elapsed [\(Date().elapsed(from: initiatedIn))]"
    }
}

final public class EvenDatastoreSaveFailed: LogEventProtocol {
    public var eventType: LogEventType { return .datastore }
    private(set) public var message: String
    public var name: String { return "CDStashFail"}

    public init(uuid: UUID, initiatedIn: Date, description: String) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "[HH:mm:ss.SSSS]"
        message = "\(description), operation <\(uuid.MD5)>: elapsed [\(Date().elapsed(from: initiatedIn))]"
    }
}

final public class EvenDatastoreWillExecute: LogEventProtocol {
    public var eventType: LogEventType { return .datastore }
    private(set) public var message: String
    public var name: String { return "CDFetchStart"}

    public init(uuid: UUID) {
        message = "operation <\(uuid.MD5)>"
    }
}

final public class EvenDatastoreDidExecute: LogEventProtocol {
    public var eventType: LogEventType { return .datastore }
    private(set) public var message: String
    public var name: String { return "CDFetchEnd"}

    public init(uuid: UUID, initiatedIn: Date) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "[HH:mm:ss.SSSS]"
        message = "operation <\(uuid.MD5)>: elapsed [\(Date().elapsed(from: initiatedIn))]"
    }
}

final public class EventCDMerge: LogEventProtocol {
    public var eventType: LogEventType { return .datastore }
    private(set) public var message: String
    public var name: String { return "CDMerge"}

    public init() {
        message = ""
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}

final class EventLocalFetch: LogEventProtocol {
    public var eventType: LogEventType { return .localFetch }
    private(set) public var message: String
    public var name: String { return "LocalFetch"}

    public init() {
        message = ""
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}
