//
//  WOTRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTRequestIdType = String

@objc
open class WOTRequest: NSObject, WOTRequestProtocol {
    override public init() {
        super.init()
    }

    deinit {
        //
    }

    override public var description: String {
        return String(describing: type(of: self))
    }

    override open var hash: Int {
        return uuid.hashValue
    }

    private var groups = [WOTRequestIdType]()

    open func cancel(with error: Error?) {}

    open func start(withArguments: WOTRequestArgumentsProtocol) throws {
        throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    // MARK: - WOTRequestProtocol

    public let uuid: UUID = UUID()

    public var availableInGroups = [WOTRequestIdType]()

    public var hostConfiguration: WOTHostConfigurationProtocol?

    public var listeners = [WOTRequestListenerProtocol]()

    public var paradigm: RequestParadigmProtocol?

    open func addGroup(_ group: WOTRequestIdType) {
        groups.append(group)
    }

    open func addListener(_ listener: WOTRequestListenerProtocol) {
        listeners.append(listener)
    }

    open func removeGroup(_ group: WOTRequestIdType) {
        groups.removeAll(where: { group.compare($0) == .orderedSame })
    }

    open func removeListener(_ listener: WOTRequestListenerProtocol) {
        if let index = listeners.firstIndex(where: { $0.hash == listener.hash }) {
            listeners.remove(at: index)
        }
    }
}
