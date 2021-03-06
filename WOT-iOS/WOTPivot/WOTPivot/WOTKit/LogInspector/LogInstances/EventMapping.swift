//
//  EventMapping.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/29/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public enum EventMappingType: String {
    case JSON
    case Array
}

public class EventMappingStart: LogEventProtocol {
    public private(set) var message: String
    public var type: LogEventType { return .mapping }
    public var name: String { return "MappingStart"}

    public init(fetchResult: FetchResult, pkCase: PKCase, mappingType: EventMappingType) {
        let context = fetchResult.context
        let managedObject = fetchResult.managedObject()
        message = "`\(mappingType)` Mapping Context: \(context.name ?? ""); \(managedObject.entity.name ?? "<unknown>") \(pkCase.description)"
    }

    required public init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = error.debugDescription
    }
}

public class EventMappingEnded: LogEventProtocol {
    public private(set) var message: String
    public var type: LogEventType { return .mapping }
    public var name: String { return "MappingEnded"}

    public init(fetchResult: FetchResult, pkCase: PKCase, mappingType: EventMappingType) {
        let context = fetchResult.context
        let managedObject = fetchResult.managedObject()
        message = "`\(mappingType)` Mapping Context: \(context.name ?? ""); \(managedObject.entity.name ?? "<unknown>") \(pkCase.description)"
    }

    required public init?(_ text: String) {
        message = text
    }

    public init?(error: Error) {
        message = error.debugDescription
    }
}
