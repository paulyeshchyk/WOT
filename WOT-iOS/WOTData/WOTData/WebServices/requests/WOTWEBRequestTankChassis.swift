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
    override public var method: String { return "POST" }

    override public var path: String {
        return "/wot/encyclopedia/tankchassis/"
    }
}

extension WOTWEBRequestTankChassis: WOTModelServiceProtocol {
    @objc
    public static func modelClass() -> AnyClass? {
        return Tankchassis.self
    }

    @objc
    public func instanceModelClass() -> AnyClass? {
        return type(of: self).modelClass()
    }
}
