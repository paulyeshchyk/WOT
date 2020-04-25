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
        let intArray = try IntArray(from: decoder)
        self.min_value = intArray.elements[0].asDecimal
        self.avg_value = intArray.elements[1].asDecimal
        self.max_value = intArray.elements[2].asDecimal
    }
}
