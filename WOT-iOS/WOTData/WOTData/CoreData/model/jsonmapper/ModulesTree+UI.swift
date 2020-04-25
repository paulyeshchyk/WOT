//
//  ModulesTree+UI.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension ModulesTree {
    @objc
    public func localImageURL() -> URL? {
        let type = self.moduleType()
        let name = type.stringValue
        return Bundle.main.url(forResource: name, withExtension: "png")
    }

    @objc
    public func moduleType() -> ObjCVehicleModuleType {
        return .unknown
    }
}
