//
//  Dictionary+URLString.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

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
