//
//  WOTRequestResponseDataParser.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class RESTResponseCoordinator: WOTResponseCoordinatorProtocol, LogMessageSender {
    private struct DataAdaptationPair {
        let dataAdapter: DataAdapterProtocol
        let data: Data?
    }

    public var appManager: WOTAppManagerProtocol?
    public var requestCoordinator: WOTRequestCoordinatorProtocol

    // MARK: - WOTResponseCoordinatorProtocol
    public required init(requestCoordinator rc: WOTRequestCoordinatorProtocol) {
        requestCoordinator = rc
    }

    public func parseResponse(data parseData: Data?, forRequest request: WOTRequestProtocol, instanceHelper: JSONAdapterInstanceHelper?, onComplete: @escaping OnRequestComplete) throws {
        guard let data = parseData else {
            throw RequestCoordinatorError.dataIsEmpty
        }

        guard let requestIds = requestCoordinator.requestIds(forRequest: request), requestIds.count > 0 else {
            onComplete(request, self, nil)
            return
        }
        var dataAdaptationPair: [DataAdaptationPair] = .init()
        requestIds.forEach({ requestIdType in
            do {
                let adapter = try requestCoordinator.responseAdapterInstance(for: requestIdType, request: request)
                adapter.onJSONDidParse = onComplete
                adapter.instanceHelper = instanceHelper
                let pair = DataAdaptationPair(dataAdapter: adapter, data: data)
                dataAdaptationPair.append(pair)
            } catch let error {
                appManager?.logInspector?.logEvent(EventError(error, details: nil), sender: self)
            }
        })

        if dataAdaptationPair.count == 0 {
            onComplete(request, self, nil)
        }

        dataAdaptationPair.forEach { (pair) in
            pair.dataAdapter.decode(binary: pair.data, forType: RESTAPIResponse.self, fromRequest: request)
        }
    }

    // MARK: LogMessageSender-
    public var logSenderDescription: String = "WOTRequestDataParser"
}
