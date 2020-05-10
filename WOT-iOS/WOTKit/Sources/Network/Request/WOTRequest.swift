//
//  WOTRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
open class WOTRequest: NSObject, WOTRequestProtocol {
    public var wotDescription: String { return description }

    public let uuid: UUID = UUID()

    @objc
    public var hostConfiguration: WOTHostConfigurationProtocol?

    @objc
    public var availableInGroups = [WOTRequestIdType]()

    @objc
    public var listeners = [WOTRequestListenerProtocol]()

    public var paradigm: RequestParadigm?

    private var groups = [WOTRequestIdType]()

    @objc
    open func addGroup(_ group: WOTRequestIdType) {
        groups.append(group)
    }

    @objc
    open func removeGroup(_ group: WOTRequestIdType) {
        groups.removeAll(where: { group.compare($0) == .orderedSame })
    }

    @objc
    open func addListener(_ listener: WOTRequestListenerProtocol) {
        listeners.append(listener)
    }

    @objc
    open func removeListener(_ listener: WOTRequestListenerProtocol) {
        if let index = listeners.firstIndex(where: { (obj) -> Bool in
            return (obj.hash == listener.hash)
        }) {
            listeners.remove(at: index)
        }
    }

    override open var hash: Int {
        return NSStringFromClass(type(of: self)).hash
    }

    open func cancel(with error: Error?) {}

    open func start(withArguments: WOTRequestArgumentsProtocol) throws {
        throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}
