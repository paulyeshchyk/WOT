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
    var swiftError: Error? { get }
}

public struct RESTAPIError: WOTError {
    public var code: Int?
    public var message: String?
    public init(code: Int?, message: String?) {
        self.code = code ?? -1
        self.message = message
    }

    public var debugDescription: String {
        return "RESTAPIError code: \(code ?? -1); message: \(message ?? "No message")"
    }

    public init?(json: JSON?) {
        let code: Int = json?["code"] as? Int ?? -1
        let message = json?["message"] as? String ?? "<unknown>"

        self = RESTAPIError(code: code, message: message)
    }
}

public class RESTAPIResponse: NSObject, RESTAPIResponseProtocol {
    public var status: RESTAPIResponseStatus? = .unknown
    public var meta: RESTAPIResponseMeta?
    public var data: JSON?
    public var error: JSON?
    public var swiftError: Error? {
        guard let json = error else { return nil }
        return RESTAPIError(json: json)
    }

    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey {
        case status
        case meta
        case data
        case error
    }

    // MARK: - Decodable

    public required convenience init(from decoder: Decoder) throws {
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

public struct RESTAPIResponseMeta: Codable {
    var count: Int?
    var page_total: Int?
    var total: Int?
    var limit: Int?
    var page: Int?

    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey {
        case count
        case page_total
        case total
        case limit
        case page
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
        self.page_total = try container.decodeIfPresent(Int.self, forKey: .page_total)
        self.total = try container.decodeIfPresent(Int.self, forKey: .total)
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        self.page = try container.decodeIfPresent(Int.self, forKey: .page)
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
