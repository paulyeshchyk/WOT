//
//  ResponseManagedObjectLinkerList.swift
//  WOTKit
//
//  Created by Paul on 16.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

// MARK: - ResponseManagedObjectLinkerList

class ResponseManagedObjectLinkerList {

    private var list: [AnyHashable: ManagedObjectLinkerProtocol] = [:]

    // MARK: Internal

    func addLinker(_ linker: ManagedObjectLinkerProtocol, forRequest: RequestProtocol) throws {
        list[forRequest.MD5] = linker
    }

    func linkerForRequest(_ request: RequestProtocol) -> ManagedObjectLinkerProtocol? {
        list[request.MD5]
    }

    func removeLinkerForRequest(_ request: RequestProtocol) throws {
        let value = list.removeValue(forKey: request.MD5)
        guard value != nil else {
            throw ResponseManagedObjectLinkerList.Errors.notRemoved(request)
        }
    }
}

// MARK: - %t + ResponseManagedObjectLinkerList.Errors

extension ResponseManagedObjectLinkerList {
    // Errors
    private enum Errors: Error, CustomStringConvertible {
        case notRemoved(RequestProtocol)
        case notFound(ManagedObjectLinkerProtocol)

        var description: String {
            switch self {
            case .notRemoved(let request): return "[\(type(of: self))]: Adapter was not removed for request \(String(describing: request))"
            case .notFound(let adapterLinker): return "[\(type(of: self))]: Adapter was not found for \(String(describing: adapterLinker))"
            }
        }
    }
}
