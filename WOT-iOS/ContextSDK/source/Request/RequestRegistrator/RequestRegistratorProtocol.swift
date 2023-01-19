//
//  WOTRequestRegistratorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - RequestRegistratorContainerProtocol

public protocol RequestRegistratorContainerProtocol {
    var requestRegistrator: RequestRegistratorProtocol? { get set }
}

// MARK: - RequestRegistratorProtocol

public protocol RequestRegistratorProtocol {
    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    func requestId(forModelClass: ModelClassType) throws -> RequestIdType
    func requestClass(for requestId: RequestIdType) -> RequestModelServiceProtocol.Type?

    func createRequest(forModelClass: ModelClassType) throws -> RequestProtocol
    func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol

    func registerServiceClass(_ serviceClass: RequestModelServiceProtocol.Type) throws
}
