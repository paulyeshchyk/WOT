//
//  URLEncodedProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public protocol URLEncodedProtocol {
    func urlEncoded() -> String?
}

extension Int: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        return "\(self)".urlEncoded()
    }
}

extension NSNumber: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        return "\(self)".urlEncoded()
    }
}

extension NSString: URLEncodedProtocol {
    @objc
    public func urlEncoded() -> String? {
        return (self as String).urlEncoded()
    }
}

extension String: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        let customAllowedSet =  NSCharacterSet(charactersIn: "%;/?¿:@&=$+,[]#!'()*<> \"\n").inverted
        return self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
    }
}

extension Array: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        var resultArray = [String]()
        self.forEach { element in
            if let text = element as? URLEncodedProtocol, let encoded = text.urlEncoded() {
                resultArray.append(encoded)
            }
        }
        return resultArray.joined(separator: ",")
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
