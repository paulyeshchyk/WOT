//
//  WOTWEBRequestLogout.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

public class LogoutHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "wot/auth/logout/"
    }

    override public var responseParserClass: ResponseParserProtocol.Type {
        RESTResponseParser.self
    }

    override public var dataAdapterClass: ResponseAdapterProtocol.Type {
        WGResponseJSONAdapter.self
    }
}

extension LogoutHttpRequest: ModelServiceProtocol {
    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return nil
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.logout.rawValue
    }

    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}
