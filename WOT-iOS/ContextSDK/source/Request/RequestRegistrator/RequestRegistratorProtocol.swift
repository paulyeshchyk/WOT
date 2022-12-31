//
//  WOTRequestRegistratorProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public protocol RequestRegistratorContainerProtocol {
    var requestRegistrator: RequestRegistratorProtocol? { get set }
}

@objc
public protocol RequestRegistratorProtocol {
    func requestIds(modelServiceClass: AnyClass) -> [RequestIdType]
    func requestClass(for requestId: RequestIdType) -> ModelServiceProtocol.Type?
    func createRequest(forRequestId requestId: RequestIdType) throws -> RequestProtocol
    func registerServiceClass(_ serviceClass: ModelServiceProtocol.Type)
}
