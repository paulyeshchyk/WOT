//
//  WOTWEBRequestTankChassis.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTankChassis: WOTWEBRequest {
    
    override public var query: [AnyHashable : Any]! {
        return [WGWebQueryArgs.application_id: self.hostConfiguration.applicationID,
                WGWebQueryArgs.fields:self.args.escapedValue(forKey: WGWebQueryArgs.fields),
                WGWebQueryArgs.module_id: self.args.escapedValue(forKey: WOTApiKeys.module_id)
        ]
    }
    
    override public var path: String! {
        return "/wot/encyclopedia/tankchassis/"
    }
}
