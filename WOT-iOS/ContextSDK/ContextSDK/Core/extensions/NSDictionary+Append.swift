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
extension Dictionary {
    /// Merge and return a new dictionary
    public func merge(with: [Key: Value]) -> [Key: Value] {
        var copy = self
        for (k, v) in with {
            // If a key is already present it will be overritten
            copy[k] = v
        }
        return copy
    }

    /// Merge in-place
    public mutating func append(with: [Key: Value]) {
        for (k, v) in with {
            // If a key is already present it will be overritten
            self[k] = v
        }
    }
}

extension Dictionary {
    public func debugOutput() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(data: jsonData, encoding: .utf8)!
        } catch {
            return "Cant make output. Fix the error: \(String(describing: error))"
        }
    }
}

extension NSDictionary {
    @objc
    public func asURLQueryString() -> String {
        var result = [String]()
        self.keyEnumerator()
            .compactMap { $0 as? String }
            .sorted(by: < )
            .forEach {
                if let escapedValue = self.escapedValue(key: $0) {
                    result.append(String(format: "%@=%@", $0, escapedValue))
                }
            }
        return result.joined(separator: "&")
    }

    @objc
    public func escapedValue(key: AnyHashable) -> String? {
        guard let obj = self.object(forKey: key) else { return nil }

        if  let array = obj as? Array<URLEncodedProtocol> {
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

extension Dictionary where Key == AnyHashable {
    public func asURLQueryString() -> String {
        var result = [String]()
        self.keys.compactMap { $0 as? String }.sorted(by: <).forEach {
            if let escapedValue = self.escapedValue(key: $0) {
                result.append(String(format: "%@=%@", $0, escapedValue))
            }
        }
        return result.joined(separator: "&")
    }

    public func escapedValue(key: AnyHashable) -> String? {
        guard let obj = self[key] else { return nil }

        if let array = obj as? Array<URLEncodedProtocol> {
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
