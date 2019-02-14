//
//  NSError+Pivot.swift
//  WOTPivot
//
//  Created on 8/21/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public extension NSError {

    struct ErrorCodes {
        static let WOT_ERROR_CODE_ENDPOINT_ERROR: Int = 1
    }

    public static func loginError(code: Int, userInfo:[String: Any]) -> NSError {
        return NSError(domain: "WOTLOGIN", code: code, userInfo: userInfo)
    }

    public static func coreDataError(code: Int, userInfo:[String: Any]) -> NSError {
        return NSError(domain: "WOTCOREDATA", code: code, userInfo: userInfo)
    }
}
