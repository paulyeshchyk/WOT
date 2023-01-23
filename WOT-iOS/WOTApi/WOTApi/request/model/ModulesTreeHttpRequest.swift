//
//  WOTWEBRequestModulesTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

public class ModulesTreeHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicles/"
    }

    override public var responseParserClass: ResponseParserProtocol.Type {
        RESTResponseParser.self
    }

    override public var dataAdapterClass: ResponseAdapterProtocol.Type {
        WGResponseJSONAdapter.self
    }
}

extension ModulesTreeHttpRequest: ModelServiceProtocol {
    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        return ModulesTree.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.moduleTree.rawValue
    }

    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}
