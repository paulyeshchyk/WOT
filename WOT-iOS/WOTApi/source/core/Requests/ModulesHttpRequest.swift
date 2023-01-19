//
//  WOTWEBRequestModules.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - ModulesHttpRequest

public class ModulesHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "/wot/encyclopedia/modules/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
}

// MARK: - ModulesHttpRequest + RequestModelServiceProtocol

extension ModulesHttpRequest: RequestModelServiceProtocol {
    public class func dataAdapterClass() -> ResponseAdapterProtocol.Type {
        WGAPIResponseJSONAdapter.self
    }

    public class func modelClass() -> ModelClassType? {
        Module.self
    }

    public class func registrationID() -> RequestIdType {
        WebRequestType.modules.rawValue
    }
}
