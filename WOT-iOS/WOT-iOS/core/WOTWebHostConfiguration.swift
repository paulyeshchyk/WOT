//
//  WOTWebHostConfiguration.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 3/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebHostConfiguration: NSObject, WebHostConfigurationProtocol {
    
    public var applicationID: String {
        return "e3a1e0889ff9c76fa503177f351b853c"
    }
    
    public var host: String {
        return String(format:"%@.%@", WOTApiDefaults.applicationHost, WOTApplicationDefaults.language())
    }
    
    public var scheme: String {
        return WOTApiDefaults.applicationScheme
    }
}
