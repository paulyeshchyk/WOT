//
//  WOTRequestResponseDataParser.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class RESTResponseCoordinator: WOTResponseCoordinatorProtocol {
    private struct DataAdaptationPair {
        let dataAdapter: DataAdapterProtocol
        let data: Data?
    }

    public var requestCoordinator: WOTRequestCoordinatorProtocol
    public var logInspector: LogInspectorProtocol
    public var requestRegistrator: WOTRequestRegistratorProtocol

    public required init(requestCoordinator: WOTRequestCoordinatorProtocol, logInspector: LogInspectorProtocol, requestRegistrator: WOTRequestRegistratorProtocol) {
        self.requestCoordinator = requestCoordinator
        self.logInspector = logInspector
        self.requestRegistrator = requestRegistrator
    }
}

// MARK: - WOTResponseCoordinatorProtocol

extension RESTResponseCoordinator {
    public func parseResponse(data parseData: Data?, forRequest request: WOTRequestProtocol, linker: JSONAdapterLinkerProtocol, onRequestComplete: @escaping OnRequestComplete) throws {
        guard let data = parseData else {
            throw RequestCoordinatorError.dataIsEmpty
        }

        let requestIds = requestCoordinator.requestIds(forRequest: request)
        guard requestIds.count > 0 else {
            onRequestComplete(request, self, nil)
            return
        }

        let localCallback: OnRequestComplete = { request, data, error in
            onRequestComplete(request, data, error)
        }

        var dataAdaptationPair: [DataAdaptationPair] = .init()
        requestIds.forEach { requestIdType in
            do {
                let adapter = try requestRegistrator.responseAdapterInstance(for: requestIdType, request: request, linker: linker)
                adapter.onJSONDidParse = localCallback
                let pair = DataAdaptationPair(dataAdapter: adapter, data: data)
                dataAdaptationPair.append(pair)
            } catch {
                self.logInspector.logEvent(EventError(error, details: nil), sender: self)
            }
        }

        if dataAdaptationPair.count == 0 {
            onRequestComplete(request, self, nil)
        }

        dataAdaptationPair.forEach { pair in
            pair.dataAdapter.decode(binary: pair.data, forType: RESTAPIResponse.self, fromRequest: request)
        }
    }
}
