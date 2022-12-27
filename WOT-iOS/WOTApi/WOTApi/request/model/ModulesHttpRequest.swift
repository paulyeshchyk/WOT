//
//  WOTWEBRequestModules.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

public class ModulesHttpRequest: HttpRequest {
    override public var httpMethod: HTTPMethod { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/modules/"
    }
}

extension ModulesHttpRequest: ModelServiceProtocol {

    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return Module.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.modules.rawValue
    }

    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}
