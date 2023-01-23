//
//  MappingCoordinatorLogEvents.swift
//  ContextSDK
//
//  Created by Paul on 1.01.23.
//

public enum EventMappingType: String {
    case JSON
    case Array
}

final class EventMappingStart: LogEventProtocol {
    public var eventType: LogEventType { return .mapping }
    private(set) public var message: String
    public var name: String { return "MappingStart" }

    public init(fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, mappingType: EventMappingType) {
        message = "`\(mappingType)` Mapping \(String(describing: fetchResult)) \(String(describing: predicate))"
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}

final class EventMappingEnded: LogEventProtocol {
    public var eventType: LogEventType { return .mapping }
    private(set) public var message: String
    public var name: String { return "MappingEnded" }

    public init(fetchResult: FetchResultProtocol, predicate: ContextPredicateProtocol, mappingType: EventMappingType) {
        message = "`\(mappingType)` Mapping \(String(describing: fetchResult)) \(String(describing: predicate))"
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}

final public class EventMappingInfo: LogEventProtocol {
    public var eventType: LogEventType { return .mapping }
    private(set) public var message: String
    public var name: String { return "MappingInfo" }

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
}
