//
//  WOTWEBRequestTankProfile.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankProfile: WOTWEBRequest, WOTModelServiceProtocol {
    
    override public var method: String { return "POST" }

    @objc
    public class func modelClassName() -> String {
        return NSStringFromClass(Vehicleprofile.self)
    }

    override public var path: String {
        return "/wot/encyclopedia/vehicleprofile/"
    }

}
