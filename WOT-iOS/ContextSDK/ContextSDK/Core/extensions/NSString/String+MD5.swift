//
//  String+MD5.swift
//  ContextSDK
//
//  Created by Paul on 22.12.22.
//

import CommonCrypto

extension UUID {
    public var MD5: String { do { return try uuidString.MD5() } catch { return "" } }
}

@objc
public class MD5: NSString {
    @objc
    public static func MD5(from: NSString) -> NSString? {
        return from.MD5_1()
    }
}

extension String  {
    private enum StringMD5Error: Error, CustomStringConvertible {
        case cantConvertToUTF8
        var description: String {
            switch self {
            case .cantConvertToUTF8: return "[\(type(of: self))]: cant convert to UTF8"
            }
        }
    }
    public func MD5() throws -> String {
        guard let messageData = self.data(using:.utf8) else {
            throw StringMD5Error.cantConvertToUTF8
        }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        _ = digestData.withUnsafeMutableBytes { (digestBytes) -> Bool in
            messageData.withUnsafeBytes({ (messageBytes) -> Bool in
                _ = CC_MD5(messageBytes.baseAddress, CC_LONG(messageData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
                return true
            })
        }
        return digestData.toHex()
    }
}

extension Data {
    public func toHex(format: String = "%02hhx") -> String {
        map{ String(format: format, $0) }.joined()
    }
}

extension NSString {
    public func MD5_1() -> NSString? {
        try? (self as String).MD5() as NSString?
    }
}
