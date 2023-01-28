//
//  NSDictionary+URLString.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

public extension NSDictionary {

    @objc
    func asURLQueryString() -> String {
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

    @objc
    func escapedValue(key: AnyHashable) -> String? {
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
