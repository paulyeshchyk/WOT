//
//  WOTWEBRequestLogin.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

@objc
public class WOTWEBRequestLogin: WOTWEBRequest {
    override public var method: HTTPMethods { return .POST }

    override public var path: String {
        return "wot/auth/login/"
    }
}

extension WOTWEBRequestLogin: WOTModelServiceProtocol {
    @objc
    public static func modelClass() -> PrimaryKeypathProtocol.Type? {
        return nil
    }

    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}
