//
//  WOTRequestProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestProtocol: WOTStartableProtocol {
    var uuid: UUID { get }
    var availableInGroups: [String] { get }
    var hostConfiguration: WOTHostConfigurationProtocol? { get set }
    var listeners: [WOTRequestListenerProtocol] { get }
    var paradigm: RequestParadigmProtocol? { get set }

    func addGroup(_ group: WOTRequestIdType)
    func addListener(_ listener: WOTRequestListenerProtocol)
    func removeGroup(_ group: String)
    func removeListener(_ listener: WOTRequestListenerProtocol)
}
