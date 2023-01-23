//
//  HostConfigurationProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - HostConfigurationContainerProtocol

@objc
public protocol HostConfigurationContainerProtocol {
    @objc var hostConfiguration: HostConfigurationProtocol? { get set }
}

// MARK: - HostConfigurationProtocol

@objc
public protocol HostConfigurationProtocol {
    @objc
    var applicationID: String { get }

    @objc
    var host: String { get }

    @objc
    var scheme: String { get }

    @objc
    func urlQuery(with: RequestArgumentsProtocol?) -> String?
}
