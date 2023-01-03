//
//  WOTWEBRequestLogin.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - LoginHttpRequest

public class LoginHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "wot/auth/login/"
    }
}

// MARK: - LoginHttpRequest + ModelServiceProtocol

extension LoginHttpRequest: ModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return nil
    }

    private class func registration1D() -> RequestIdType {
        WebRequestType.login.rawValue
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.login.rawValue
    }
}
