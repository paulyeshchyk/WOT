//
//  DatastoreLogEvents.swift
//  ContextSDK
//
//  Created by Paul on 1.01.23.
//

// MARK: - EvenDatastoreWillSave

final public class EvenDatastoreWillSave: LogEventProtocol {

    public init(uuid: UUID, description: String) {
        message = "\(description), operation <\(uuid.MD5)>"
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .datastore }
    public var name: String { return "CDStashStart" }
}

// MARK: - EvenDatastoreDidSave

final public class EvenDatastoreDidSave: LogEventProtocol {

    public init(uuid: UUID, initiatedIn: Date, description: String) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "[HH:mm:ss.SSSS]"
        message = "\(description), operation <\(uuid.MD5)>: elapsed [\(Date().elapsed(from: initiatedIn))]"
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .datastore }
    public var name: String { return "CDStashEnded" }
}

// MARK: - EvenDatastoreSaveFailed

final public class EvenDatastoreSaveFailed: LogEventProtocol {

    public init(uuid: UUID, initiatedIn: Date, description: String) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "[HH:mm:ss.SSSS]"
        message = "\(description), operation <\(uuid.MD5)>: elapsed [\(Date().elapsed(from: initiatedIn))]"
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .datastore }
    public var name: String { return "CDStashFail" }
}

// MARK: - EvenDatastoreWillExecute

final public class EvenDatastoreWillExecute: LogEventProtocol {

    public init(uuid: UUID) {
        message = "operation <\(uuid.MD5)>"
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .datastore }
    public var name: String { return "CDFetchStart" }
}

// MARK: - EvenDatastoreDidExecute

final public class EvenDatastoreDidExecute: LogEventProtocol {

    public init(uuid: UUID, initiatedIn: Date) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "[HH:mm:ss.SSSS]"
        message = "operation <\(uuid.MD5)>: elapsed [\(Date().elapsed(from: initiatedIn))]"
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .datastore }
    public var name: String { return "CDFetchEnd" }
}

// MARK: - EventCDMerge

final public class EventCDMerge: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .datastore }
    public var name: String { return "CDMerge" }
}

// MARK: - EventLocalFetch

final class EventLocalFetch: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .localFetch }
    public var name: String { return "LocalFetch" }
}
