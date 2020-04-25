//
//  VehicleprofileArmor+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileArmor)
public class VehicleprofileArmor: NSManagedObject {}

extension VehicleprofileArmor {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case front
        case sides
        case rear
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }
}

extension VehicleprofileArmor: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.front = try container.decodeAnyIfPresent(Int.self, forKey: .front)?.asDecimal
        self.sides = try container.decodeAnyIfPresent(Int.self, forKey: .sides)?.asDecimal
        self.rear = try container.decodeAnyIfPresent(Int.self, forKey: .rear)?.asDecimal
    }
}
