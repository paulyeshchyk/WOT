//
//  VehicleprofileTurret+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - KeypathProtocol

public extension VehicleprofileTurret {

    @objc
    override static func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    override class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        // tag was used when parsed response vehicleprofile-suspension
        switch forType {
        case .external: return #keyPath(VehicleprofileTurret.turret_id)
        case .internal: return #keyPath(VehicleprofileTurret.tag)
        default: fatalError("unknown type should never be used")
        }
    }
}
