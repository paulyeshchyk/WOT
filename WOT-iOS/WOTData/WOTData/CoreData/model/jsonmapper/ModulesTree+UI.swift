//
//  ModulesTree+UI.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
extension ModulesTree {
    @objc
    public func localImageURL() -> URL? {
        let type = self.moduleType()
        let name = type.stringValue
        return Bundle.main.url(forResource: name, withExtension: "png")
    }

    @objc
    public func moduleType() -> ObjCVehicleModuleType {
        if let next = self.next_engines, next.count > 0 {
            return .engine
        }
        if let next = self.next_chassis, next.count > 0 {
            return .chassis
        }
        if let next = self.next_guns, next.count > 0 {
            return .guns
        }
        if let next = self.next_radios, next.count > 0 {
            return .radios
        }
        if let next = self.next_turrets, next.count > 0 {
            return .turrets
        }
        return .unknown
    }
}
