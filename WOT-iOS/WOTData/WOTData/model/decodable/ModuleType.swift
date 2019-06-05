//
//  ModuleType.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/30/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    public enum ModuleType: String, Codable {
        case vehicleGun
        case vehicleChassis
        case vehicleTurret
        case vehicleEngine
        case vehicleRadio
    }

}
