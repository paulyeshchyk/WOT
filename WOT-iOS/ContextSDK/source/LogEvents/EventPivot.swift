//
//  EventDebug.swift
//  ContextSDK
//
//  Created by Paul on 3.01.23.
//

final public class EventPivot: LogEventProtocol {

    public init() {
        message = ""
    }

    public required init?(_ debugDescriptable: Any) {
        message = String(describing: debugDescriptable)
    }

    private(set) public var message: String

    public var eventType: LogEventType { return .pivot }
    public var name: String { return "Pivot" }
}
