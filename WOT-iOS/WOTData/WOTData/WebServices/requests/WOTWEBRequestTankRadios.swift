//
//  WOTWebRequestTankRadios.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankRadios: WOTWEBRequest, WOTModelServiceProtocol {

    override public var method: String { return "POST" }
    
    @available(*, deprecated, message: "TO be refactored")
    @objc
    public class func modelClassName() -> String {
        return NSStringFromClass(Tankradios.self)
    }

    @available(*, deprecated, message: "TO be refactored")
    @objc
    public func instanceModelClass() -> AnyClass? {
        return NSClassFromString( type(of: self).modelClassName() )
    }

    override public var path: String {
        return "/wot/encyclopedia/tankradios/"
    }
}
