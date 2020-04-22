//
//  Meta+WOTWebResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

public typealias OnLinksCallback = ([WOTJSONLink]?) -> Void

@objc
public protocol CoreDataMappingProtocol {
    /**
     */
    func onLinks(_ links: [WOTJSONLink]?)
    /**
     Asks NSManagedObjectContext to find/create object by predicate
     - Parameter clazz: Type of requested object
     - Parameter pkCase: Set of predicates available for this request
     - Parameter callback: -
     */
    func requestNewSubordinate(_ clazz: AnyClass, _ pkCase: PKCase, callback: @escaping NSManagedObjectCallback )

    /**
     Asks Subordinator to save context before running links mapping
        - Parameter pkCase: just informative

     */
    func stash(_ pkCase: PKCase)
}

public protocol JSONMapperProtocol {
    associatedtype Fields

    mutating func mapping(fromJSON jSON: JSON)
    func mapping(fromArray array: [Any])

    func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?)
    func mapping(fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?)
}

extension JSONMapperProtocol {
    public func mapping(fromJSON jSON: JSON) {}
    public func mapping(fromArray array: [Any]) {}
    public func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {}
    public func mapping(fromArray array: [Any], pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {}
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
    public var data: JSON?
    public var error: JSON?

    public enum FieldKeys: String, CodingKey {
        case status
        case meta
        case data
    }

    public typealias Fields = FieldKeys

    public func mapping(fromJSON jSON: JSON) {
        self.status = WOTWebResponseStatus(rawValue: (jSON["status"] as? String) ?? "") ?? .unknown
        self.data = jSON["data"] as? JSON
        self.error = jSON["error"] as? JSON

        let meta = WOTWebResponseMeta(count: 0, page_total: 0, total: 0, limit: 0, page: nil)
        if let metaJSON = jSON["meta"] as? JSON {
            meta.mapping(fromJSON: metaJSON)
        }
        self.meta = meta
    }

    public func mapping(fromArray array: [Any]) {}
}

public protocol WOTErrorProtocol {
    var wotDescription: String { get }
}

struct WOTWEBRequestError: Error, WOTErrorProtocol {
    enum ErrorKind {
        case dataIsNull
        case emptyJSON
        case invalidStatus
        case parseError
        case requestError(JSON?)

        var description: String {
            switch self {
            case .dataIsNull: return "dataIsNull"
            case .emptyJSON: return "emptyJSON"
            case .invalidStatus: return "invalidStatus"
            case .parseError: return "parseError"
            case .requestError(let dict):
                if let message = dict?["message"] {
                    return "requestError: \(message)"
                } else {
                    if let debugDescr = dict?.description {
                        return "requestError: \(debugDescr)"
                    } else {
                        return "requestError: unknown"
                    }
                }
            }
        }
    }

    let kind: ErrorKind

    var description: String {
        return kind.description
    }

    var wotDescription: String {
        return kind.description
    }
}

public typealias JSONParseCompletion = (JSON?, Error?) -> Void

@objc extension NSData {
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
