//
//  WOTWebRequestTankTurrets.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankTurrets: WOTWEBRequest, WOTModelServiceProtocol {
    
    override public var method: String { return "POST" }

    @objc
    public class func modelClassName() -> String {
        return NSStringFromClass(Tankturrets.self)
    }

    override public var path: String {
        return "/wot/encyclopedia/tankturrets/"
    }
}
