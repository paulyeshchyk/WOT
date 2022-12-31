//
//  WOTWEBRequestLogout.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

public class LogoutHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "wot/auth/logout/"
    }
}

extension LogoutHttpRequest: ModelServiceProtocol {
    public class func responseParserClass() -> ResponseParserProtocol.Type {
        RESTResponseParser.self
    }

    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return nil
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.logout.rawValue
    }
}
