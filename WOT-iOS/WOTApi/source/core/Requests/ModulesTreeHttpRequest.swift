//
//  WOTWEBRequestModulesTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

public class ModulesTreeHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicles/"
    }
}

extension ModulesTreeHttpRequest: ModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        ModulesTree.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.moduleTree.rawValue
    }
}
