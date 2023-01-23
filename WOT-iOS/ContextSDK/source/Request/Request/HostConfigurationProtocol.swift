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
    var hostConfiguration: HostConfigurationProtocol? { get set }
}

// MARK: - HostConfigurationProtocol

@objc
public protocol HostConfigurationProtocol {

    var applicationID: String { get }
    var host: String { get }
    var scheme: String { get }
    func urlQuery(with: RequestArgumentsProtocol?) -> String?
}
