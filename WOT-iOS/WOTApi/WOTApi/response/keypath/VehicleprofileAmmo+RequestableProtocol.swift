//
//  VehicleprofileAmmo+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - KeypathProtocol

extension VehicleprofileAmmo {
    //
    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case type
        case stun
        case damage
        case penetration
    }

    override public static func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        switch forType {
        case .external: return #keyPath(VehicleprofileAmmo.type)
        case .internal: return #keyPath(VehicleprofileAmmo.type)
        }
    }
}
