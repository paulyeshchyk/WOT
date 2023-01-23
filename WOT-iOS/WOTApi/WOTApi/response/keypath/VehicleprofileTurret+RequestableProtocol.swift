//
//  VehicleprofileTurret+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - KeypathProtocol

extension VehicleprofileTurret {
    //
    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case traverse_left_arc
        case traverse_speed
        case weight
        case view_range
        case hp
        case tier
        case name
        case tag
        case traverse_right_arc
    }

    @objc
    override public static func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        //id was used when quering remote module
        //tag was used when parsed response vehicleprofile-suspension
        switch forType {
        case .external: return #keyPath(VehicleprofileTurret.turret_id)
        case .internal: return #keyPath(VehicleprofileTurret.tag)
        }
    }
}
