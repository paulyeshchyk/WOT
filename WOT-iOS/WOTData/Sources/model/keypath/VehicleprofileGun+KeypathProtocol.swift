//
//  VehicleprofileGun+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import CoreData

// MARK: - KeypathProtocol

extension VehicleprofileGun {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case move_down_arc
        case caliber
        case name
        case weight
        case move_up_arc
        case fire_rate
        case dispersion
        case tag
        case reload_time
        case tier
        case aim_time
    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        //id was used when quering remote module
        switch forType {
        case .external: return #keyPath(VehicleprofileGun.gun_id)
        case .internal: return #keyPath(VehicleprofileGun.tag)
        }
    }

    override open class func predicateFormat(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external:
            return "%K == %@"
        default:
            return "%K = %@"
        }
    }
}
