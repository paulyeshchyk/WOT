//
//  WOTWEBRequestTanks.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/14/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWEBRequestTanks: WOTWEBRequest {

    override public var method: String { return "POST" }

    override public var path: String {
        return "/wot/encyclopedia/tanks/"
    }
}

extension WOTWEBRequestTanks: WOTModelServiceProtocol {

    @objc
    public static func modelClass() -> AnyClass? {
        return Vehicles.self
    }
    
    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }

}
