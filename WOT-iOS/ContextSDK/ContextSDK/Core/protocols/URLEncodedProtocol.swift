//
//  URLEncodedProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

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
