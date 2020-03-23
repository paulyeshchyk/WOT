//
//  Dictionary_URLQuery.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension NSDictionary {
    @objc
    public func asURLQueryString() -> String {
        var result = [String]()
        self.keyEnumerator().map{ $0 as? String }.compactMap{ $0 }.forEach {
            if let escapedValue = self.escapedValue(key: $0) {
                result.append(String(format:"%@=%@", $0, escapedValue))
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

        guard let urlCodable = obj as? URLEncodedProtocol else {
            return nil
        }
        return urlCodable.urlEncoded()
    }
}

extension Dictionary where Key == AnyHashable {
    public func asURLQueryString() -> String {
        var result = [String]()
        self.keys.map{ $0 as? String }.compactMap{ $0 }.forEach {
            if let escapedValue = self.escapedValue(key: $0) {
                result.append(String(format:"%@=%@", $0, escapedValue))
            }
        }
        return result.joined(separator: "&")
    }

    public func escapedValue(key: AnyHashable) -> String? {
        guard let obj = self[key] else { return nil }

        if  let array = obj as? Array<URLEncodedProtocol> {
            return array.urlEncoded()
        }

        guard let urlCodable = obj as? URLEncodedProtocol else {
            print("obj is not confrming URLEncodedProtocol")
            return nil
        }
        return urlCodable.urlEncoded()
    }
}
