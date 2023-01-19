//
//  WOTRequestRegistratorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - RequestRegistratorContainerProtocol

@objc
public protocol RequestRegistratorContainerProtocol {
    var requestRegistrator: RequestRegistratorProtocol? { get set }
}

// MARK: - RequestRegistratorProtocol

@objc
public protocol RequestRegistratorProtocol {

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    func createRequest(requestConfiguration: RequestConfigurationProtocol, responseConfiguration: ResponseConfigurationProtocol) throws -> RequestProtocol

    func registerServiceClass(_ serviceClass: RequestModelServiceProtocol.Type) throws
}
