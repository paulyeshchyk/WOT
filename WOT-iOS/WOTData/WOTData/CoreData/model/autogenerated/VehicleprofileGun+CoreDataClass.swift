//
//  VehicleprofileGun+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileGun)
public class VehicleprofileGun: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileGun {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case move_down_arc
        case caliber
        case name
        case weight
        case move_up_arc
        case fire_rate
        case dispersion
        case tag
        case reload_time
        case tier
        case aim_time
    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath() -> String {
        //tag was used when parsed response vehicleprofile-gun
        return #keyPath(VehicleprofileGun.tag)
    }

    override public class func primaryIdKeyPath() -> String {
        //id was used when quering remote module
        return #keyPath(VehicleprofileGun.gun_id)
    }
}

// MARK: - Mapping
extension VehicleprofileGun {
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)
    }
}

// MARK: - JSONDecoding
extension VehicleprofileGun: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.caliber = try container.decodeAnyIfPresent(Int.self, forKey: .caliber)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.move_down_arc = try container.decodeAnyIfPresent(Int.self, forKey: .move_down_arc)?.asDecimal
        self.move_up_arc = try container.decodeAnyIfPresent(Int.self, forKey: .move_up_arc)?.asDecimal
        self.fire_rate = try container.decodeAnyIfPresent(Int.self, forKey: .fire_rate)?.asDecimal
        self.dispersion = try container.decodeAnyIfPresent(Float.self, forKey: .dispersion)?.asDecimal
        self.reload_time = try container.decodeAnyIfPresent(Int.self, forKey: .reload_time)?.asDecimal
        self.aim_time = try container.decodeAnyIfPresent(Int.self, forKey: .aim_time)?.asDecimal
    }
}
