//
//  VehicleprofileEngine+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import WOTKit

// MARK: - KeypathProtocol

public extension VehicleprofileEngine {
    //
    typealias Fields = DataFieldsKeys
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case fire_chance
        case name
        case power
        case tag
        case tier
        case weight
    }

    @objc
    override class func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }

    override class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        // tag was used when parsed response vehicleprofile-engine
        switch forType {
        case .external: return #keyPath(VehicleprofileEngine.engine_id)
        case .internal: return #keyPath(VehicleprofileEngine.tag)
        }
    }
}
