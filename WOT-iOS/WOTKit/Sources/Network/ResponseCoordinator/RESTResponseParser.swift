//
//  WOTRequestResponseDataParser.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/30/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

open class RESTResponseParser: ResponseParserProtocol {
    private let appContext: Context

    required public init(appContext: Context) {
        self.appContext = appContext
    }

    // MARK: - ResponseParserProtocol

    #warning("2b removed")
    open func parseResponse(data parseData: Data?, forRequest request: RequestProtocol, dataAdapter: ResponseAdapterProtocol?, completion: @escaping ResponseAdapterProtocol.OnComplete) throws {
        guard let data = parseData else {
            throw RESTResponseParserError.dataIsEmpty
        }

        guard let dataAdapter = dataAdapter else {
            throw RESTResponseParserError.noAdapterFound
        }

        dataAdapter.decode(data: data, fromRequest: request, completion: completion)
    }
}

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
