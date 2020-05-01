//
//  VehicleprofileEngine+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileEngine)
public class VehicleprofileEngine: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileEngine {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case fire_chance
        case name
        case power
        case tag
        case tier
        case weight
    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }


    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        //id was used when quering remote module
        //tag was used when parsed response vehicleprofile-engine
        switch forType {
        case .external: return #keyPath(VehicleprofileEngine.engine_id)
        case .internal:return #keyPath(VehicleprofileEngine.tag)
        }
        
    }
}

// MARK: - Mapping
extension VehicleprofileEngine {
    @objc
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)
    }
}

// MARK: - JSONDecoding
extension VehicleprofileEngine: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.fire_chance = try container.decodeAnyIfPresent(Float.self, forKey: .fire_chance)?.asDecimal
        self.power = try container.decodeAnyIfPresent(Int.self, forKey: .power)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
    }
}
