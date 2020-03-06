//
//  WOTWEBRequestModulesTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestModulesTree : WOTWEBRequest, WOTModelServiceProtocol {
    
    @objc
    public class func modelClassName() -> String {
        return NSStringFromClass(ModulesTree.self)
    }

    override public var path: String {
        return "/wot/encyclopedia/modules/"
    }
    
    override public var method: String {
        return "POST"
    }
}
