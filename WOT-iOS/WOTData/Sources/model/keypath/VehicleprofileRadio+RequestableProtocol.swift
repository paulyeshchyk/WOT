//
//  VehicleprofileRadio+KeypathProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - KeypathProtocol

extension VehicleprofileRadio {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case tier
        case signal_range
        case tag
        case weight
        case name
    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String? {
        //id was used when quering remote module
        //tag was used when parsed response vehicleprofile-radio
        switch forType {
        case .external: return #keyPath(VehicleprofileRadio.radio_id)
        case .internal: return #keyPath(VehicleprofileRadio.tag)
        }
    }
}
