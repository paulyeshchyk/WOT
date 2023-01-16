//
//  JSONValueProtocol.swift
//  ContextSDK
//
//  Copyright https://onmyway133.com/posts/how-to-encode-json-dictionary-into-jsonencoder/
//

public typealias JSONValueType = Any
public typealias KeypathType = Swift.AnyHashable
public typealias JSON = [KeypathType: JSONValueType]

// MARK: - JSONValue

public enum JSONValue {

    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case json([KeyType: JSONValue])
    case array([JSONValue])

    public typealias KeyType = String

}

// MARK: - JSONValue + Encodable

extension JSONValue: Encodable {

    // swiftlint:disable cyclomatic_complexity
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string): try container.encode(string)
        case .int(let int): try container.encode(int)
        case .bool(let bool): try container.encode(bool)
        case .double(let double): try container.encode(double)
        case .json(let json): try container.encode(json)
        case .array(let array): try container.encode(array)
        }
        // swiftlint:enable cyclomatic_complexity
    }
}

extension JSONValue {

    // swiftlint:disable cyclomatic_complexity
    public init?(any: Any?) {
        if let value = any as? String {
            self = .string(value)
        } else if let value = any as? Int {
            self = .int(value)
        } else if let value = any as? Double {
            self = .double(value)
        } else if let value = any as? Bool {
            self = .bool(value)
        } else if let jsonArray = any as? [Any] {
            let array = jsonArray.compactMap { JSONValue(any: $0) }
            self = .array(array)
        } else if let json = any as? [JSONValue.KeyType: Any] {
            var dict: [JSONValue.KeyType: JSONValue] = [:]
            for key in json.keys.sorted() {
                dict[key] = JSONValue(any: json[key])
            }
            self = .json(dict)
        } else {
            return nil
        }
        // swiftlint:enable cyclomatic_complexity
    }

    func encode(encoding: String.Encoding = .utf8) throws -> String? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)

        return String(data: data, encoding: encoding)
    }
}
