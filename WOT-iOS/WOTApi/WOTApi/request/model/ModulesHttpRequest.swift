//
//  WOTWEBRequestModules.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

@objc
public class ModulesHttpRequest: HttpRequest {
    override public var method: HTTPMethods { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/modules/"
    }
}

extension ModulesHttpRequest: WOTModelServiceProtocol {
    @objc
    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return Module.self
    }

    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}
