//
//  VehicleprofileArmor+KeyPathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - KeypathProtocol

public extension VehicleprofileArmor {
    //
    typealias Fields = DataFieldsKeys
    enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case front
        case sides
        case rear
    }

    @objc
    override static func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }
}
