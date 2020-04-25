//
//  Data+JSON.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

public typealias JSONParseCompletion = (JSON?, Error?) -> Void

extension NSData {
    @available(*, deprecated, message: "Use Data.parseAsJSON(:) instead")
    @objc
    public func parseAsJSON(_ completion: JSONParseCompletion?) {
        (self as Data).parseAsJSON(completion)
    }
}

extension Data {
    public func parseAsJSON(_ completion: JSONParseCompletion?) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self as Data, options: [.mutableLeaves, .mutableContainers])
            guard let json = jsonObject as? JSON else {
                let error = WOTWEBRequestError(kind: .emptyJSON)
                completion?(nil, error)
                return
            }

            let response = WOTWebResponse()
            response.mapping(fromJSON: json)
            switch response.status {
            case .ok: completion?(response.data, nil)
            case .error:
                let error = WOTWEBRequestError(kind: WOTWEBRequestError.ErrorKind.requestError(response.error))
                completion?(nil, error)
                return
            default:
                let error = WOTWEBRequestError(kind: .invalidStatus)
                completion?(nil, error)
                return
            }

        } catch {
            let error = WOTWEBRequestError(kind: .parseError)
            completion?(nil, error)
            return
        }
    }
}
