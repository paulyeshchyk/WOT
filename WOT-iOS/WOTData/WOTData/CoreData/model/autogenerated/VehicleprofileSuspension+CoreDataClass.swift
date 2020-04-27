//
//  VehicleprofileSuspension+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileSuspension)
public class VehicleprofileSuspension: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileSuspension {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case tier
        case traverse_speed
        case name
        case load_limit
        case weight
        case steering_lock_angle
        case tag
    }

//    public enum RelativeKeys: String, CodingKey, CaseIterable {
//        case suspension_id
//    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

//    @objc
//    override public class func relationsKeypaths() -> [String] {
//        return RelativeKeys.allCases.compactMap { $0.rawValue }
//    }

    override public class func primaryKeyPath() -> String {
        //tag was used when parsed response vehicleprofile-suspension
        return #keyPath(VehicleprofileSuspension.tag)
    }

    override public class func primaryIdKeyPath() -> String {
        //id was used when quering remote module
        return #keyPath(VehicleprofileSuspension.suspension_id)
    }
}

// MARK: - Mapping
extension VehicleprofileSuspension {
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

// MARK: - JSONDecoding
extension VehicleprofileSuspension: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.load_limit = try container.decodeAnyIfPresent(Int.self, forKey: .load_limit)?.asDecimal
        self.steering_lock_angle = try container.decodeAnyIfPresent(Int.self, forKey: .steering_lock_angle)?.asDecimal
    }
}
