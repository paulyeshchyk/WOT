//
//  String+MD5.swift
//  ContextSDK
//
//  Created by Paul on 22.12.22.
//

import CommonCrypto

extension UUID {
    public var MD5: String? {
        uuidString.MD5()
    }
}

@objc
public class MD5: NSString {
    @objc
    public static func MD5(from: NSString) -> NSString? {
        return from.MD5_1()
    }
}

extension String  {
    public func MD5() -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let d = self.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes({ body in
                CC_MD5(body, CC_LONG(d.count), &digest)
            })
        }

        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
 }

extension NSString {
    public func MD5_1() -> NSString? {
        (self as String).MD5() as NSString?
    }
}
