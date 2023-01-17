//
//  WOTWEBRequestLogin.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - LoginHttpRequest

public class LoginHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "wot/auth/login/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
}

// MARK: - LoginHttpRequest + RequestModelServiceProtocol

extension LoginHttpRequest: RequestModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public static func modelClass() -> ModelClassType? {
        return nil
    }

    private class func registration1D() -> RequestIdType {
        WebRequestType.login.rawValue
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.login.rawValue
    }
}
