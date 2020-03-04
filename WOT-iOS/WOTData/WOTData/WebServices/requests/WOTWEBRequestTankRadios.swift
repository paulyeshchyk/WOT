//
//  WOTWebRequestTankRadios.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankRadios: WOTWEBRequest {

    override public var method: String { return "POST" }
    
    @objc
    override public class var modelClassName: String {
        return NSStringFromClass(Tankradios.self)
    }
    
    override public var path: String {
        return "/wot/encyclopedia/tankradios/"
    }
}
