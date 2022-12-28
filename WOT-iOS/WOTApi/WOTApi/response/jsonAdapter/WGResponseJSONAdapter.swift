//
//  WGResponseJSONAdapter.swift
//  WOTApi
//
//  Created by Paul on 27.12.22.
//

import ContextSDK

public class WGResponseJSONAdapter: JSONAdapter {
    public enum WGResponseJSONAdapterError: Error, CustomStringConvertible {
        case jsonByKeyWasNotFound(JSON,AnyHashable)
        case notSupportedType(AnyClass)
        public var description: String {
            switch self {
            case .notSupportedType(let clazz): return "\(type(of: self)): \(type(of: clazz)) can't be adopted"
            case .jsonByKeyWasNotFound(let json, let key): return "\(type(of: self)): json was not found for key:\(key)); {\(json)}"
            }
        }
    }

    override public func decodeData(_ data: Data?, forType: AnyClass, fromRequest request: RequestProtocol, completion: ((RequestProtocol, Error?) -> Void)?) {
        guard let resultType = forType as? WGAPIResponse.Type else {
            completion?(request, WGResponseJSONAdapterError.notSupportedType(forType.self))
            return
        }
        guard let data = data else {
            didFinish(with: nil, fromRequest: request, error: nil, completion: completion)
            return
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(resultType.self, from: data)
            if let swiftError = result.swiftError {
                didFinish(with: nil, fromRequest: request, error: swiftError, completion: completion)
            } else {
                didFinish(with: result.data, fromRequest: request, error: nil, completion: completion)
            }
        } catch {
            didFinish(with: nil, fromRequest: request, error: error, completion: completion)
        }
    }
}
