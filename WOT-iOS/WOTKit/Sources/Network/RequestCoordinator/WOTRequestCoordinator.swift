//
//  WOTRequestCoordinator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/6/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTRequestCoordinator: NSObject, WOTRequestCoordinatorProtocol {

    private var requestRegistrator: WOTRequestRegistratorProtocol

    private var logInspector: LogInspectorProtocol

    public required init(requestRegistrator: WOTRequestRegistratorProtocol, logInspector: LogInspectorProtocol) {
        self.requestRegistrator = requestRegistrator
        self.logInspector = logInspector
        super.init()
    }
}

// MARK: - WOTRequestCoordinatorProtocol

extension WOTRequestCoordinator {
    public func createRequest(forRequestId requestId: WOTRequestIdType) throws -> WOTRequestProtocol {
        guard
            let Clazz = requestRegistrator.requestClass(for: requestId) as? NSObject.Type, Clazz.conforms(to: WOTRequestProtocol.self),
            let result = Clazz.init() as? WOTRequestProtocol else {
            throw RequestCoordinatorError.requestNotFound
        }
        return result
    }

    public func requestIds(forRequest request: WOTRequestProtocol) -> [WOTRequestIdType] {
        guard let modelClass = requestRegistrator.modelClass(forRequest: request) else {
            let eventError = EventError(message: "model class not found for request\(type(of: request))")
            logInspector.logEvent(eventError, sender: self)
            return []
        }

        let result = requestRegistrator.requestIds(forClass: modelClass)
        guard result.count > 0 else {
            let eventError = EventError(message: "\(type(of: modelClass)) was not registered for request \(type(of: request))")
            logInspector.logEvent(eventError, sender: self)
            return []
        }
        return result
    }
}
