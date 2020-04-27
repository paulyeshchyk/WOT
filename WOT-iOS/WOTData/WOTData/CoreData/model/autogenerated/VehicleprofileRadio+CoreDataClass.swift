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

// MARK: - Coding Keys
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

    override public class func primaryKeyPath() -> String {
        //tag was used when parsed response vehicleprofile-radio
        return #keyPath(VehicleprofileRadio.tag)
    }

    override public class func primaryIdKeyPath() -> String {
        //id was used when quering remote module
        return #keyPath(VehicleprofileRadio.radio_id)
    }
}

// MARK: - Mapping
extension VehicleprofileRadio {
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

// MARK: - JSONDecoding
extension VehicleprofileRadio: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.signal_range = try container.decodeAnyIfPresent(Int.self, forKey: .signal_range)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
    }
}
