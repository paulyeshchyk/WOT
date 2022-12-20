//
//  VehicleprofileSuspension+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - KeypathProtocol

extension VehicleprofileSuspension {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case tier
        case traverse_speed
        case name
        case load_limit
        case weight
        case steering_lock_angle
        case tag
    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        //id was used when quering remote module
        //tag was used when parsed response vehicleprofile-suspension

        switch forType {
        case .external: return #keyPath(VehicleprofileSuspension.suspension_id)
        case .internal: return #keyPath(VehicleprofileSuspension.tag)
        }
    }
}
