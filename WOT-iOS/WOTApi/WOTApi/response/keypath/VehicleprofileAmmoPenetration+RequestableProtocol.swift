//
//  VehicleprofileAmmoPenetration+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit

// MARK: - KeypathProtocol

extension VehicleprofileAmmoPenetration {
    //
    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey, CaseIterable {
        case min_value
        case avg_value
        case max_valie
    }

    @objc
    override public static func dataFieldsKeypaths() -> [String] {
        return DataFieldsKeys.allCases.compactMap { $0.rawValue }
    }
}
