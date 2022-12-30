//
//  Vehicleprofile+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import WOTKit

// MARK: - KeypathProtocol

public extension Vehicleprofile {
    //
    typealias Fields = DataFieldsKeys
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case max_ammo
        case weight
        case hp
        case is_default
        case hull_weight
        case speed_forward
        case hull_hp
        case speed_backward
        case tank_id
        case max_weight
    }

    enum RelativeKeys: String, CodingKey, CaseIterable {
        case modules
        case modulesTree
    }

    @objc
    override static func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override static func relationFieldsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(Vehicleprofile.hashName)
        case .internal: return #keyPath(Vehicleprofile.hashName)
        }
    }
}
