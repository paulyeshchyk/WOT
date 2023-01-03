//
//  EventFlow.swift
//  ContextSDK
//
//  Created by Paul on 28.12.22.
//

// MARK: - EventFlowStart

@objc
public class EventFlowStart: NSObject, LogEventProtocol {

    override public init() {
        message = "<unknown>"
        super.init()
    }

    @objc
    public required init?(_ message: String) {
        self.message = message
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .flow }
    public var name: String { return "FlowStart" }
}

// MARK: - EventFlowEnd

@objc
public class EventFlowEnd: NSObject, LogEventProtocol {

    override public init() {
        message = "<unknown>"
        super.init()
    }

    @objc
    public required init?(_ message: String) {
        self.message = message
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .flow }
    public var name: String { return "FlowEnd" }
}
