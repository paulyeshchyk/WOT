//
//  EventFlow.swift
//  ContextSDK
//
//  Created by Paul on 28.12.22.
//

@objc
public class EventFlowStart: NSObject, LogEventProtocol {
    public var eventType: LogEventType { return .flow }
    private(set) public var message: String
    public var name: String { return "FlowStart" }

    override public init() {
        message = "<unknown>"
        super.init()
    }

    @objc
    public required init?(_ message: String) {
        self.message = message
    }
}

@objc
public class EventFlowEnd: NSObject, LogEventProtocol {
    public var eventType: LogEventType { return .flow }
    private(set) public var message: String
    public var name: String { return "FlowEnd" }

    override public init() {
        message = "<unknown>"
        super.init()
    }

    @objc
    public required init?(_ message: String) {
        self.message = message
    }
}
