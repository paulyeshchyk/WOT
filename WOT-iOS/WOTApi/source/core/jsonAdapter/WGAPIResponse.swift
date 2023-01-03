//
//  RESTAPIResponseProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

import ContextSDK

// MARK: - APIResponse

public protocol APIResponse: Codable {}

// MARK: - WGAPIResponseProtocol

public protocol WGAPIResponseProtocol: APIResponse {
    var status: WGAPIResponseStatus? { get set }
    var data: JSON? { get set }
    var error: JSON? { get set }
    var swiftError: Error? { get }
}

// MARK: - WGAPIResponse

public class WGAPIResponse: WGAPIResponseProtocol {

    // MARK: - Decodable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        status = try container.decodeIfPresent(WGAPIResponseStatus.self, forKey: .status)
        meta = try container.decodeIfPresent(WGAPIResponseMeta.self, forKey: .meta)
        data = try container.decodeIfPresent([String: Any].self, forKey: .data)
        error = try container.decodeIfPresent([String: Any].self, forKey: .error)
    }

    //
    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey {
        case status
        case meta
        case data
        case error
    }

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

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Fields.self)
        try container.encode(status, forKey: .status)
        try container.encode(meta, forKey: .meta)
    }
}

// MARK: - WGAPIResponseMeta

public struct WGAPIResponseMeta: Codable {

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
        page_total = try container.decodeIfPresent(Int.self, forKey: .page_total)
        total = try container.decodeIfPresent(Int.self, forKey: .total)
        limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
    }

    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey {
        case count
        case page_total
        case total
        case limit
        case page
    }

    var count: Int?
    var page_total: Int?
    var total: Int?
    var limit: Int?
    var page: Int?
}

// MARK: - WGAPIResponseStatus

public enum WGAPIResponseStatus: String, Codable {
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

    public typealias RawValue = String
}

// MARK: - WGAPIError

public class WGAPIError: Error {

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        code = try container.decodeIfPresent(Int.self, forKey: .code)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }

    public var code: Int?
    public var message: String?

}

// MARK: - WGAPIError + CustomStringConvertible, Codable

extension WGAPIError: CustomStringConvertible, Codable {

    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey {
        case code
        case message
    }

    public var description: String {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(decoding: data, as: UTF8.self)
        } catch {
            return "[\(type(of: self))]: Unknown error"
        }
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Fields.self)
        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
    }
}
