//
//  WOTWEBRequestModules.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

public class ModulesHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/modules/"
    }
}

extension ModulesHttpRequest: ModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        Module.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.modules.rawValue
    }
}
