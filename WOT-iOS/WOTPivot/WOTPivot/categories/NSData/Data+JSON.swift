//
//  Data+JSON.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public typealias JSONParseCompletion = (JSON?, Error?) -> Void

extension NSData {
    @available(*, deprecated, message: "Use RESTAPIResponse")
    @objc
    public func parseAsJSON(_ completion: JSONParseCompletion?) {
        (self as Data).parseAsJSON(completion)
    }
}

extension Data {
    @available(*, deprecated, message: "Use RESTAPIResponse")
    public func parseAsJSON(_ completion: JSONParseCompletion?) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self as Data, options: [.mutableLeaves, .mutableContainers])
            guard let json = jsonObject as? JSON else {
                let error = WOTWEBRequestError(kind: .emptyJSON)
                completion?(nil, error)
                return
            }

            let response = WGResponseObject()
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

@available(*, deprecated, message: "Use RESTAPIResponse")
public class WGResponseObject: NSObject, JSONMapperProtocol {
    public var status: RESTAPIResponseStatus = .unknown
    public var meta: RESTAPIResponseMeta?
    public var data: JSON?
    public var error: JSON?
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey {
        case status
        case meta
        case data
    }

    public func mapping(fromJSON jSON: JSON) {
        self.status = RESTAPIResponseStatus(rawValue: (jSON["status"] as? String) ?? "") ?? .unknown
        self.data = jSON["data"] as? JSON
        self.error = jSON["error"] as? JSON

        let meta = RESTAPIResponseMeta(count: 0, page_total: 0, total: 0, limit: 0, page: nil)
        if let metaJSON = jSON["meta"] as? JSON {
            meta.mapping(fromJSON: metaJSON)
        }
        self.meta = meta
    }

    public func mapping(fromArray array: [Any]) {}
}
