//
//  WOTRequestResponseDataParser.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class RESTResponseParser: WOTResponseParserProtocol {
    private struct DataAdaptationPair {
        let dataAdapter: DataAdapterProtocol
        let data: Data?
    }

    public required init() {
        //
    }
}

// MARK: - WOTResponseParserProtocol

extension RESTResponseParser {
    public func parseResponse(data parseData: Data?, forRequest request: WOTRequestProtocol, adapters: [DataAdapterProtocol], onParseComplete: @escaping OnParseComplete) throws {
        guard let data = parseData else {
            throw RequestCoordinatorError.dataIsEmpty
        }

        let localCallback: OnParseComplete = { request, data, error in
            onParseComplete(request, data, error)
        }

        var dataAdaptationPair: [DataAdaptationPair] = .init()
        adapters.forEach { adapter in
            adapter.onJSONDidParse = localCallback
            let pair = DataAdaptationPair(dataAdapter: adapter, data: data)
            dataAdaptationPair.append(pair)
        }

        if dataAdaptationPair.count == 0 {
            onParseComplete(request, self, nil)
        }

        dataAdaptationPair.forEach { pair in
            pair.dataAdapter.decode(binary: pair.data, forType: RESTAPIResponse.self, fromRequest: request)
        }
    }
}