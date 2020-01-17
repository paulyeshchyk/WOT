//
//  WOTWEBRequestTankEngines.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankEngines: WOTWEBRequest {

    @objc
    public class func instanceClassName() -> String! {
        return NSStringFromClass(Tankengines.self)
    }

    override public var query: [AnyHashable : Any]! {
        
        //TODO: refactor
        let fields = self.args?.escapedValue(forKey: WGWebQueryArgs.fields) ?? ""
        let module_id = self.args?.escapedValue(forKey: WGWebQueryArgs.module_id) ?? ""
        
        return [WGWebQueryArgs.application_id: self.hostConfiguration.applicationID,
                WGWebQueryArgs.fields: fields,
                WGWebQueryArgs.module_id: module_id]
    }
    
    override public var path: String! {
        return "/wot/encyclopedia/tankengines/"
    }
}
