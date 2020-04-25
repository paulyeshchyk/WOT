//
//  VehicleprofileRadio+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileRadio)
public class VehicleprofileRadio: NSManagedObject {}

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

    override public class func primaryKeyPath() -> String? {
        return #keyPath(VehicleprofileRadio.radio_id)
    }
}
