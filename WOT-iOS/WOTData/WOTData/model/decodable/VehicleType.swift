//
//  VehicleType.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/30/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WebLayer {

    public enum VehicleType: String, Codable {
        case heavyTank
        case mediumTank
        case lightTank
        case SPG
        case AT_SPG = "AT-SPG"
    }
}
