//
//  WOTWEBRequestTankEngines.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankEngines: WOTWEBRequest, WOTModelServiceProtocol {
    
    override public var method: String { return "POST" }

    @objc
    public static func modelClassName() -> String {
//        return NSStringFromClass(TanksEngines.self)
        return ""
    }

    override public var path: String {
        return "/wot/encyclopedia/tankengines/"
    }
}
