//
//  WOTHostConfigurationProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTHostConfigurationProtocol {
    @objc
    var applicationID: String { get }

    @objc
    var host: String { get }

    @objc
    var scheme: String { get }

    @objc
    func urlQuery(with: WOTRequestArgumentsProtocol) -> String
}

@objc
public protocol WOTHostConfigurationOwner {
    @objc
    var hostConfiguration: WOTHostConfigurationProtocol? { get set }
}
