//
//  RESTAPIResponseProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

import ContextSDK

public protocol APIResponse: Codable {}

public protocol WGAPIResponseProtocol: APIResponse {
    var status: WGAPIResponseStatus? { get set }
    var data: JSON? { get set }
    var error: JSON? { get set }
    var swiftError: Error? { get }
}

public class WGAPIResponse: WGAPIResponseProtocol {
    public var status: WGAPIResponseStatus? = .unknown
    public var meta: WGAPIResponseMeta?
    public var data: JSON?
    public var error: JSON?
    public var swiftError: Error? {
        guard let json = error else { return nil }
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            return try JSONDecoder().decode(WGAPIError.self, from: data)
        } catch {
            return nil
        }
    }

    //
    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey {
        case status
        case meta
        case data
        case error
    }

    // MARK: - Decodable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        self.status = try container.decodeIfPresent(WGAPIResponseStatus.self, forKey: .status)
        self.meta = try container.decodeIfPresent(WGAPIResponseMeta.self, forKey: .meta)
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

public struct WGAPIResponseMeta: Codable {
    var count: Int?
    var page_total: Int?
    var total: Int?
    var limit: Int?
    var page: Int?

    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey {
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

public enum WGAPIResponseStatus: String, Codable {
    public typealias RawValue = String

    case ok
    case error
    case unknown

    init?(value: String) {
        if value.lowercased().compare(WGAPIResponseStatus.ok.rawValue) == .orderedSame {
            self = .ok
        } else if value.lowercased().compare(WGAPIResponseStatus.error.rawValue) == .orderedSame {
            self = .error
        } else {
            self = .unknown
        }
    }
}

public class WGAPIError: Error, CustomStringConvertible, Codable {
    public var code: Int?
    public var message: String?

    public var description: String {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(decoding: data, as: UTF8.self)
        } catch {
            return "[\(type(of: self))]: Unknown error"
        }
    }

    //
    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey {
        case code
        case message
    }

    // MARK: - Decodable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        self.code = try container.decodeIfPresent(Int.self, forKey: .code)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Fields.self)
        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
    }
}
