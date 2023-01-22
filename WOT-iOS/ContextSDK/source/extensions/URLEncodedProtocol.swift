//
//  URLEncodedProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

// MARK: - URLEncodedProtocol

public protocol URLEncodedProtocol {
    func urlEncoded() -> String?
}

// MARK: - Int + URLEncodedProtocol

extension Int: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        return "\(self)".urlEncoded()
    }
}

// MARK: - NSNumber + URLEncodedProtocol

extension NSNumber: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        return "\(self)".urlEncoded()
    }
}

// MARK: - NSString + URLEncodedProtocol

extension NSString: URLEncodedProtocol {

    @objc public func urlEncoded() -> String? {
        return (self as String).urlEncoded()
    }
}

// MARK: - String + URLEncodedProtocol

extension String: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        let customAllowedSet = NSCharacterSet(charactersIn: "%;/?¿:@&=$+,[]#!'()*<> \"\n").inverted
        return addingPercentEncoding(withAllowedCharacters: customAllowedSet)
    }
}

// MARK: - Array + URLEncodedProtocol

extension Array: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        var resultArray = [String]()
        forEach { element in
            if let text = element as? URLEncodedProtocol, let encoded = text.urlEncoded() {
                resultArray.append(encoded)
            }
        }
        return resultArray.joined(separator: ",")
    }
}
