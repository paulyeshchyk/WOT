//
//  VehicleprofileModule+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - KeypathProtocol

extension VehicleprofileModule {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case radio_id
        case suspension_id
        case module_id
        case engine_id
        case gun_id
        case turret_id
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        switch forType {
        case .external: return #keyPath(VehicleprofileModule.module_id)
        case .internal: return #keyPath(VehicleprofileModule.module_id)
        case .none: return nil
        }
    }
}
