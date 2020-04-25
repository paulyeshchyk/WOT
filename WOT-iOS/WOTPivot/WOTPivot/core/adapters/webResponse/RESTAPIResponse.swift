//
//  RESTAPIResponse.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/25/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol RESTAPIResponseProtocol: Codable {
    var status: RESTAPIResponseStatus? { get set }
    var data: JSON? { get set }
    var error: JSON? { get set }
}

public class RESTAPIResponse: NSObject, RESTAPIResponseProtocol {
    public var status: RESTAPIResponseStatus? = .unknown
    public var meta: RESTAPIResponseMeta?
    public var data: JSON?
    public var error: JSON?
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey {
        case status
        case meta
        case data
        case error
    }

    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: Fields.self)
        self.status = try container.decodeIfPresent(RESTAPIResponseStatus.self, forKey: .status)
        self.meta = try container.decodeIfPresent(RESTAPIResponseMeta.self, forKey: .meta)
        self.data = try container.decodeIfPresent([String: Any].self, forKey: .data)
        self.error = try container.decodeIfPresent([String: Any].self, forKey: .error)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Fields.self)
        try container.encode(status, forKey: .status)
        try container.encode(meta, forKey: .meta)
    }
}

public struct RESTAPIResponseMeta {
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

extension RESTAPIResponseMeta: Codable {}

extension RESTAPIResponseMeta: JSONMapperProtocol {
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

public enum RESTAPIResponseStatus: String, Codable {
    public typealias RawValue = String

    case ok
    case error
    case unknown

    init?(value: String) {
        if value.lowercased().compare(RESTAPIResponseStatus.ok.rawValue) == .orderedSame {
            self = .ok
        } else if value.lowercased().compare(RESTAPIResponseStatus.error.rawValue) == .orderedSame {
            self = .error
        } else {
            self = .unknown
        }
    }
}
