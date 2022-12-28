//
//  WOTRequestResponseDataParser.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class RESTResponseParser: ResponseParserProtocol {
    private let appContext: Context
    private struct DataAdaptationPair {
        let dataAdapter: ResponseAdapterProtocol
        let data: Data?
    }

    required public init(appContext: Context) {
        self.appContext = appContext
    }
}

// MARK: - ResponseParserProtocol

extension RESTResponseParser {
    private enum RESTResponseParserError: Error, CustomStringConvertible {
        case dataIsEmpty
        case noAdapterFound
        var description: String {
            switch self {
            case .dataIsEmpty: return "[\(type(of: self))]: Data is Empty"
            case .noAdapterFound: return "[\(type(of: self))]: No Adapter found"
            }
        }
    }

    public func parseResponse(data parseData: Data?, forRequest request: RequestProtocol, dataAdapters: [ResponseAdapterProtocol]?, completion: @escaping ResponseAdapterProtocol.OnComplete) throws {
        guard let data = parseData else {
            throw RESTResponseParserError.dataIsEmpty
        }

        guard let dataAdapters = dataAdapters, dataAdapters.count != 0 else {
            throw RESTResponseParserError.noAdapterFound
        }

        var dataAdaptationPair = [DataAdaptationPair]()
        dataAdapters.forEach { dataAdapter in
            let pair = DataAdaptationPair(dataAdapter: dataAdapter, data: data)
            dataAdaptationPair.append(pair)
        }

        dataAdaptationPair.forEach { pair in
            pair.dataAdapter.decodeData(pair.data, forType: WGAPIResponse.self, fromRequest: request, completion: completion)
        }
    }
}
