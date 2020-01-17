//
//  WOTWEBRequestModulesTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestModulesTree : WOTWEBRequest {
    
    public class func instanceClassName() -> String! {
        return NSStringFromClass(ModulesTree.self)
    }

    override public var query: [AnyHashable : Any]! {
        let fields = self.args?.escapedValue(forKey: WGWebQueryArgs.fields) ?? ""
        return [WGWebQueryArgs.application_id: self.hostConfiguration.applicationID,
                WGWebQueryArgs.fields: fields]
    }
    
    override public var path: String! {
        return "/wot/encyclopedia/modules/"
    }
    
    override public var method: String! {
        return "POST"
    }
}
