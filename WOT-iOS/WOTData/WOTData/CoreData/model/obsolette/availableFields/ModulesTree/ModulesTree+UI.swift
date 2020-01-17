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
    public func moduleType() -> WOTModuleType {
        
        if let next = self.nextEngines, next.count > 0 {
            return .engine
        }
        if let next = self.nextChassis, next.count > 0 {
            return .chassis
        }
        if let next = self.nextGuns, next.count > 0 {
            return .guns
        }
        if let next = self.nextRadios, next.count > 0 {
            return .radios
        }
        if let next = self.nextTurrets, next.count > 0 {
            return .turrets
        }
        return .unknown
    }
}
