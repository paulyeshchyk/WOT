//
//  VehicleprofileAmmoDamage+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileAmmoDamage)
public class VehicleprofileAmmoDamage: NSManagedObject {}

extension VehicleprofileAmmoDamage {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case min_value
        case avg_value
        case max_value
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }
}

extension VehicleprofileAmmoDamage: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Fields.self)
        //
//        if let array = try container.decodeArray()
    }
}
