//
//  WOTRequestResponseDataParser.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class RESTResponseCoordinator: WOTResponseParserProtocol {
    private struct DataAdaptationPair {
        let dataAdapter: DataAdapterProtocol
        let data: Data?
    }

    public var logInspector: LogInspectorProtocol
    public var requestRegistrator: WOTRequestRegistratorProtocol

    public required init(logInspector: LogInspectorProtocol, requestRegistrator: WOTRequestRegistratorProtocol) {
        self.logInspector = logInspector
        self.requestRegistrator = requestRegistrator
    }
}

// MARK: - WOTResponseParserProtocol

extension RESTResponseCoordinator {
    public func parseResponse(data parseData: Data?, forRequest request: WOTRequestProtocol, adapters: [DataAdapterProtocol], linker: JSONAdapterLinkerProtocol, onRequestComplete: @escaping OnRequestComplete) throws {
        guard let data = parseData else {
            throw RequestCoordinatorError.dataIsEmpty
        }

        let localCallback: OnRequestComplete = { request, data, error in
            onRequestComplete(request, data, error)
        }

        var dataAdaptationPair: [DataAdaptationPair] = .init()
        adapters.forEach { adapter in
            adapter.onJSONDidParse = localCallback
            let pair = DataAdaptationPair(dataAdapter: adapter, data: data)
            dataAdaptationPair.append(pair)
        }

        if dataAdaptationPair.count == 0 {
            onRequestComplete(request, self, nil)
        }

        dataAdaptationPair.forEach { pair in
            pair.dataAdapter.decode(binary: pair.data, forType: RESTAPIResponse.self, fromRequest: request)
        }
    }
}
