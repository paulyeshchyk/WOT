//
//  String_UrlEncode.swift
//  WOTPivot
//
//  Created on 2/11/19.
//  Copyright © 2019. All rights reserved.
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

@objc
extension NSString: URLEncodedProtocol {
    
    @objc
    public func urlEncoded() -> String? {
        return (self as? String)?.urlEncoded()
    }
}


extension String: URLEncodedProtocol {
    public func urlEncoded() -> String? {
        let customAllowedSet =  NSCharacterSet(charactersIn:"%;/?¿:@&=$+,[]#!'()*<> \"\n").inverted
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
