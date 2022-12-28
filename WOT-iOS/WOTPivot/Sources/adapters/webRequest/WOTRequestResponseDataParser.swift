//
//  WOTRequestResponseDataParser.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestResponseDataParserProtocol {
    var appManager: WOTAppManagerProtocol? { get set }

    init(requestCoordinator: WOTRequestCoordinatorProtocol)
    func parseResponseData(_ parseData: Data?, forRequest request: WOTRequestProtocol, onObjectDidParse: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete) throws
}

public class WOTRESTResponseDataParser: WOTRequestResponseDataParserProtocol, LogMessageSender {
    private struct DataAdaptationPair {
        let dataAdapter: DataAdapterProtocol
        let data: Data?
    }

    public var appManager: WOTAppManagerProtocol?
    public var requestCoordinator: WOTRequestCoordinatorProtocol
    // MARK: - WOTRequestDataParserProtocol
    public required init(requestCoordinator rc: WOTRequestCoordinatorProtocol) {
        requestCoordinator = rc
    }

    public func parseResponseData(_ parseData: Data?, forRequest request: WOTRequestProtocol, onObjectDidParse: NSManagedObjectErrorCompletion?, onRequestComplete: @escaping OnRequestComplete) throws {
        guard let data = parseData else {
            throw RequestCoordinatorError.dataIsEmpty
        }

        guard let requestIds = requestCoordinator.requestIds(forRequest: request), !requestIds.isEmpty else {
            onRequestComplete(request, self, nil)
            return
        }
        var dataAdaptationPair: [DataAdaptationPair] = .init()
        requestIds.forEach({ requestIdType in
            do {
                let adapter = try requestCoordinator.responseAdapterInstance(for: requestIdType, request: request)
                adapter.onComplete = onRequestComplete
                adapter.onObjectDidParse = onObjectDidParse
                let pair = DataAdaptationPair(dataAdapter: adapter, data: data)
                dataAdaptationPair.append(pair)
            } catch let error {
                appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: self)
            }
        })

        if dataAdaptationPair.isEmpty {
            onRequestComplete(request, self, nil)
        }

        dataAdaptationPair.forEach { (pair) in
            pair.dataAdapter.decode(binary: pair.data, forType: RESTAPIResponse.self, fromRequest: request)
        }
    }

    // MARK: LogMessageSender-
    public var logSenderDescription: String = "WOTRequestDataParser"
}
