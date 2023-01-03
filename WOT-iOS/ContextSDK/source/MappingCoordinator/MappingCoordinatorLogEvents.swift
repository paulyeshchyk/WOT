//
//  MappingCoordinatorLogEvents.swift
//  ContextSDK
//
//  Created by Paul on 1.01.23.
//

// MARK: - EventMappingType

public enum EventMappingType: String {
    case JSON
    case Array
}

// MARK: - EventMappingStart

final class EventMappingStart: LogEventProtocol {

    public init(fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, mappingType: EventMappingType) {
        message = "`\(mappingType)` Mapping \(String(describing: fetchResult)) \(String(describing: predicate))"
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .mapping }
    public var name: String { return "MappingStart" }
}

// MARK: - EventMappingEnded

final class EventMappingEnded: LogEventProtocol {

    public init(fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, mappingType: EventMappingType) {
        message = "`\(mappingType)` Mapping \(String(describing: fetchResult)) \(String(describing: predicate))"
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .mapping }
    public var name: String { return "MappingEnded" }
}

// MARK: - EventMappingInfo

final public class EventMappingInfo: LogEventProtocol {

    public init(fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, mappingType: EventMappingType) {
        message = "`\(mappingType)` Mapping \(String(describing: fetchResult)) \(String(describing: predicate))"
    }

    public required init?(_ text: String) {
        message = text
    }

    public required init?(_ error: Error?) {
        if let error = error {
            message = String(describing: error)
        } else {
            message = "Unknown error"
        }
    }

    public init?(error: Error) {
        message = String(describing: error)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .mapping }
    public var name: String { return "MappingInfo" }
}
