//
//  WOTWEBRequestModulesTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - ModulesTreeHttpRequest

public class ModulesTreeHttpRequest: HttpRequest {

    override public var httpMethod: HTTPMethod { return .POST }
    override public var path: String { return "/wot/encyclopedia/vehicles/" }
    override public var httpQueryItemName: String { WGWebQueryArgs.fields }
}

// MARK: - ModulesTreeHttpRequest + RequestModelServiceProtocol

extension ModulesTreeHttpRequest: RequestModelServiceProtocol {
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
