//
//  VehicleprofileSuspension+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - KeypathProtocol

public extension VehicleprofileSuspension {
    //
    typealias Fields = DataFieldsKeys
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case tier
        case traverse_speed
        case name
        case load_limit
        case weight
        case steering_lock_angle
        case tag
    }

    @objc
    override class func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    override class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        // tag was used when parsed response vehicleprofile-suspension

        switch forType {
        case .external: return #keyPath(VehicleprofileSuspension.suspension_id)
        case .internal: return #keyPath(VehicleprofileSuspension.tag)
        default: fatalError("unknown type should never be used")
        }
    }
}
