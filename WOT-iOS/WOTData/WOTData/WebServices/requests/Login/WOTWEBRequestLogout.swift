//
//  WOTWEBRequestLogout.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestLogout: WOTWEBRequest {
    
    override public var method: String {
        return "POST"
    }
    
    override public var path: String {
        return "wot/auth/logout/"
    }
}
