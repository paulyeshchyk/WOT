//
//  ResponseManagedObjectExtractorList.swift
//  WOTKit
//
//  Created by Paul on 16.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - ResponseManagedObjectExtractorList

class ResponseManagedObjectExtractorList {

    private var list: [AnyHashable: ManagedObjectExtractable] = [:]

    // MARK: Internal

    func addExtractor(_ adapter: ManagedObjectExtractable, forRequest: RequestProtocol) throws {
        list[forRequest.MD5] = adapter
    }

    func extractorForRequest(_ request: RequestProtocol) -> ManagedObjectExtractable? {
        list[request.MD5]
    }

    func removeExtractorForRequest(_ request: RequestProtocol) throws {
        let value = list.removeValue(forKey: request.MD5)
        guard value != nil else {
            throw ResponseManagedObjectExtractorList.Errors.notRemoved(request)
        }
    }
}

// MARK: - %t + ResponseManagedObjectExtractorList.Errors

extension ResponseManagedObjectExtractorList {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case notRemoved(RequestProtocol)
        case notFound(ManagedObjectLinkerProtocol)

        var description: String {
            switch self {
            case .notRemoved(let request): return "[\(type(of: self))]: Extractor was not removed for request \(String(describing: request))"
            case .notFound(let adapterLinker): return "[\(type(of: self))]: Extractor was not found for \(String(describing: adapterLinker))"
            }
        }
    }
}
