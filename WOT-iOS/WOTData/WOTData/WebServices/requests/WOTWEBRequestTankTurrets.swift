//
//  WOTWebRequestTankTurrets.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankTurrets: WOTWEBRequest {
    
    override public var method: String { return "POST" }

    override public var path: String {
        return "/wot/encyclopedia/tankturrets/"
    }
}

extension WOTWEBRequestTankTurrets: WOTModelServiceProtocol {
    
    @objc
    public class func modelClass() -> AnyClass? {
        return Tankturrets.self
    }
    
    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}
