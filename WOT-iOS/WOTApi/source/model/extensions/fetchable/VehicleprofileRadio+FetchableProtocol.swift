//
//  VehicleprofileRadio+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - KeypathProtocol

public extension VehicleprofileRadio {

    @objc
    override class func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    override class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        // tag was used when parsed response vehicleprofile-radio
        switch forType {
        case .external: return #keyPath(VehicleprofileRadio.radio_id)
        case .internal: return #keyPath(VehicleprofileRadio.tag)
        default: fatalError("unknown type should never be used")
        }
    }
}
