//
//  EventMapping.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/29/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public enum EventMappingType: String {
    case JSON
    case Array
}

public class EventMappingStart: LogEventProtocol {
    public var eventType: LogEventType { return .mapping }
    public private(set) var message: String
    public var name: String { return "MappingStart" }

    public init(fetchResult: FetchResultProtocol, predicate: RequestPredicate, mappingType: EventMappingType) {
        message = "`\(mappingType)` Mapping \(String(describing: fetchResult)) \(String(describing: predicate))"
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}

public class EventMappingEnded: LogEventProtocol {
    public var eventType: LogEventType { return .mapping }
    public private(set) var message: String
    public var name: String { return "MappingEnded" }

    public init(fetchResult: FetchResultProtocol, predicate: RequestPredicate, mappingType: EventMappingType) {
        message = "`\(mappingType)` Mapping \(String(describing: fetchResult)) \(String(describing: predicate))"
    }

    public required init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = String(describing: error)
    }
}
