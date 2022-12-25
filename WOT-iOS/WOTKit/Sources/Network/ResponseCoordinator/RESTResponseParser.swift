//
//  WOTRequestResponseDataParser.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class RESTResponseParser: ResponseParserProtocol {
    
    public typealias Context = LogInspectorContainerProtocol

    private let context: Context
    private struct DataAdaptationPair {
        let dataAdapter: DataAdapterProtocol
        let data: Data?
    }

    public init(context: Context) {
        self.context = context
    }
}

// MARK: - ResponseParserProtocol

extension RESTResponseParser {
    private enum RESTResponseParserError: Error {
        case dataIsEmpty
        case noAdapterFound
    }
    
    public func parseResponse(data parseData: Data?, forRequest request: RequestProtocol, adapters: [DataAdapterProtocol]?, completion: @escaping DataAdapterProtocol.OnComplete) throws {
        guard let data = parseData else {
            throw RESTResponseParserError.dataIsEmpty
        }

        guard let adapters = adapters, adapters.count != 0 else {
            throw RESTResponseParserError.noAdapterFound
        }
        
        var dataAdaptationPair = [DataAdaptationPair]()
        adapters.forEach { adapter in
            let pair = DataAdaptationPair(dataAdapter: adapter, data: data)
            dataAdaptationPair.append(pair)
        }

        dataAdaptationPair.forEach { pair in
            (pair.dataAdapter as? JSONAdapter)?.decode(binary: pair.data, forType: RESTAPIResponse.self, fromRequest: request, completion: completion)
        }
    }
}
