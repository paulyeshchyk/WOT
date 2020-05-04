//
//  WOTRequestProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestProtocol: WOTStartableProtocol, Describable {
    @objc
    var hostConfiguration: WOTHostConfigurationProtocol? { get set }

    @objc
    var listeners: [WOTRequestListenerProtocol] { get }

    @objc
    func addListener(_ listener: WOTRequestListenerProtocol)

    @objc
    func removeListener(_ listener: WOTRequestListenerProtocol)

    @objc
    var availableInGroups: [String] { get }

    @objc
    func addGroup(_ group: WOTRequestIdType)

    @objc
    func removeGroup(_ group: String)

    var uuid: UUID { get }

    @objc
    var predicate: RequestPredicate? { get set }
}
