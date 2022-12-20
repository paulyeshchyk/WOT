//
//  WOTRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
open class WOTRequest: NSObject, RequestProtocol {

    override public var description: String {
        return String(describing: type(of: self))
    }

    override open var hash: Int {
        return uuid.hashValue
    }

    private var groups = [WOTRequestIdType]()

    open func cancel(with error: Error?) {}

    open func start(withArguments: RequestArgumentsProtocol) throws {
        throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    // MARK: - WOTRequestProtocol

    public let uuid: UUID = UUID()

    public var availableInGroups = [WOTRequestIdType]()

    public var hostConfiguration: HostConfigurationProtocol?

    public var listeners = [RequestListenerProtocol]()

    public var paradigm: MappingParadigmProtocol?

    open func addGroup(_ group: WOTRequestIdType) {
        groups.append(group)
    }

    open func addListener(_ listener: RequestListenerProtocol) {
        listeners.append(listener)
    }

    open func removeGroup(_ group: WOTRequestIdType) {
        groups.removeAll(where: { group.compare($0) == .orderedSame })
    }

    open func removeListener(_ listener: RequestListenerProtocol) {
        if let index = listeners.firstIndex(where: { $0.hash == listener.hash }) {
            listeners.remove(at: index)
        }
    }
}
