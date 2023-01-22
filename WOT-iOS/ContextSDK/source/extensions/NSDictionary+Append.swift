//
//  NSDictionary+Append.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

import Foundation

/*
 https://medium.com/ios-swift-development-notes/swiftbites-8-merging-dictionaries-in-swift-894c3e235fec
 */
public extension Dictionary {
    /// Merge and return a new dictionary
    func merge(with: [Key: Value]) -> [Key: Value] {
        var copy = self
        for (k, v) in with {
            // If a key is already present it will be overritten
            copy[k] = v
        }
        return copy
    }

    /// Merge in-place
    mutating func append(with: [Key: Value]) {
        for (k, v) in with {
            // If a key is already present it will be overritten
            self[k] = v
        }
    }
}

extension Dictionary where Key == AnyHashable, Value == Any {
    public func debugOutput() -> String {
        guard let jsonValue = JSONValue(any: self) else {
            return "Invalid json"
        }
        do {
            return try jsonValue.encode()?.unescaped ?? "Encoding error: <unknown>"
        } catch {
            return "Encoding error: \(error)"
        }
    }
}

public extension NSDictionary {

    @objc func asURLQueryString() -> String {
        var result = [String]()
        keyEnumerator()
            .compactMap { $0 as? String }
            .sorted(by: <)
            .forEach {
                if let escapedValue = self.escapedValue(key: $0) {
                    result.append(String(format: "%@=%@", $0, escapedValue))
                }
            }
        return result.joined(separator: "&")
    }

    @objc func escapedValue(key: AnyHashable) -> String? {
        guard let obj = object(forKey: key) else { return nil }

        if let array = obj as? [URLEncodedProtocol] {
            return array.urlEncoded()
        }

        if let dict = obj as? NSDictionary {
            return dict.asURLQueryString()
        }

        guard let urlCodable = obj as? URLEncodedProtocol else {
            return nil
        }
        return urlCodable.urlEncoded()
    }
}

public extension Dictionary where Key == AnyHashable {
    func asURLQueryString() -> String {
        var result = [String]()
        keys.compactMap { $0 as? String }.sorted(by: <).forEach {
            if let escapedValue = self.escapedValue(key: $0) {
                result.append(String(format: "%@=%@", $0, escapedValue))
            }
        }
        return result.joined(separator: "&")
    }

    func escapedValue(key: AnyHashable) -> String? {
        guard let obj = self[key] else { return nil }

        if let array = obj as? [URLEncodedProtocol] {
            return array.urlEncoded()
        }

        if let dict = obj as? Dictionary {
            return dict.asURLQueryString()
        }

        guard let urlCodable = obj as? URLEncodedProtocol else {
            print("obj is not conforming to URLEncodedProtocol:\(obj)")
            return nil
        }
        return urlCodable.urlEncoded()
    }
}
