//
//  WOTWEBRequestModulesTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

@objc
public class WOTWEBRequestModulesTree: HttpRequest {
    override public var method: HTTPMethods { return .POST }

    override public var path: String {
        return "/wot/encyclopedia/vehicles/"
    }

}

extension WOTWEBRequestModulesTree: WOTModelServiceProtocol {
    @objc
    public class func modelClass() -> PrimaryKeypathProtocol.Type? {
        return ModulesTree.self
    }

    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}
