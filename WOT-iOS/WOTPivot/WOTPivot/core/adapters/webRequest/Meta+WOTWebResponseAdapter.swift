//
//  Meta+WOTWebResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

public protocol JSONMapperProtocol {
    associatedtype Fields

    mutating func mapping(fromJSON jSON: JSON)
    func mapping(fromArray array: [Any])

    func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void)
    func mapping(fromArray array: [Any], into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void)
}

extension JSONMapperProtocol {
    public func mapping(fromJSON jSON: JSON) {}
    public func mapping(fromArray array: [Any]) {}
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {}
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey, linksCallback: @escaping ([WOTJSONLink]?) -> Void) {}
}

public enum WOTWebResponseStatus: String {
    public typealias RawValue = String

    case ok
    case error
    case unknown

    init?(value: String) {
        if value.lowercased().compare(WOTWebResponseStatus.ok.rawValue) == .orderedSame {
            self = .ok
        } else if value.lowercased().compare(WOTWebResponseStatus.error.rawValue) == .orderedSame {
            self = .error
        } else {
            self = .unknown
        }
    }
}

public struct WOTWebResponseMeta {
    var count: Int
    var page_total: Int
    var total: Int
    var limit: Int
    var page: Int?
    init(count: Int, page_total: Int, total: Int, limit: Int, page: Int?) {
        self.count = count
        self.page_total = page_total
        self.total = total
        self.limit = limit
        self.page = page
    }
}

extension WOTWebResponseMeta: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case count
        case page_total
        case total
        case limit
        case page
    }

    public typealias Fields = FieldKeys

    mutating public func mapping(fromJSON jSON: JSON) {
        count = jSON["count"] as? Int ?? 0
        page_total = jSON["page_total"] as? Int ?? 0
        total = jSON["total"] as? Int ?? 0
        limit = jSON["limit"] as? Int ?? 0
        page = jSON["page"] as? Int
    }
}

public class WOTWebResponse: NSObject, JSONMapperProtocol {
    public var status: WOTWebResponseStatus = .unknown
    public var meta: WOTWebResponseMeta?
    public var data: [AnyHashable: Any]?
    public var error: [AnyHashable: Any]?

    public enum FieldKeys: String, CodingKey {
        case status
        case meta
        case data
    }

    public typealias Fields = FieldKeys

    public func mapping(fromJSON jSON: JSON) {
        self.status = WOTWebResponseStatus(rawValue: (jSON["status"] as? String) ?? "") ?? .unknown
        self.data = jSON["data"] as? [AnyHashable: Any]
        self.error = jSON["error"] as? [AnyHashable: Any]

        let meta = WOTWebResponseMeta(count: 0, page_total: 0, total: 0, limit: 0, page: nil)
        if let metaJSON = jSON["meta"] as? [AnyHashable: Any] {
            meta.mapping(fromJSON: metaJSON)
        }
        self.meta = meta
    }

    public func mapping(fromArray array: [Any]) {}
}

struct WOTWEBRequestError: Error {
    enum ErrorKind {
        case dataIsNull
        case emptyJSON
        case invalidStatus
        case parseError
        case requestError([AnyHashable: Any]?)

        var description: String {
            switch self {
            case .dataIsNull: return "dataIsNull"
            case .emptyJSON: return "emptyJSON"
            case .invalidStatus: return "invalidStatus"
            case .parseError: return "parseError"
            case .requestError(let dict): return "requestError:(\(dict.debugDescription))"
            }
        }
    }

    let kind: ErrorKind

    var description: String {
        return kind.description
    }
}

public typealias JSONParseCompletion = (JSON?) -> Void

@objc extension NSData {
    @available(*, deprecated, message: "Use Data.parseAsJSON(:) instead")
    @objc
    @discardableResult
    public func parseAsJSON(_ completion: JSONParseCompletion?) -> Error? {
        return (self as Data).parseAsJSON(completion)
    }
}

extension Data {
    @discardableResult
    public func parseAsJSON(_ completion: JSONParseCompletion?) -> Error? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: self as Data, options: [.mutableLeaves, .mutableContainers])
            guard let json = jsonObject as? JSON else {
                return WOTWEBRequestError(kind: .emptyJSON)
            }

            let response = WOTWebResponse()
            response.mapping(fromJSON: json)
            switch response.status {
            case .ok: completion?(response.data)
            case .error: return WOTWEBRequestError(kind: WOTWEBRequestError.ErrorKind.requestError(response.error))
            default: return WOTWEBRequestError(kind: .invalidStatus)
            }

        } catch {
            return WOTWEBRequestError(kind: .parseError)
        }

        return nil
    }
}
