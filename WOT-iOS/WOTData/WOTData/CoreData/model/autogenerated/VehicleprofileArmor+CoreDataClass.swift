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

// MARK: - Coding Keys
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

// MARK: - Mapping
extension VehicleprofileArmor {
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
    }
}

// MARK: - JSONDecoding
extension VehicleprofileArmor: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.front = try container.decodeAnyIfPresent(Int.self, forKey: .front)?.asDecimal
        self.sides = try container.decodeAnyIfPresent(Int.self, forKey: .sides)?.asDecimal
        self.rear = try container.decodeAnyIfPresent(Int.self, forKey: .rear)?.asDecimal
    }
}

extension VehicleprofileArmor {
    @available(*, deprecated, message: "deprecated")
    public static func hull(fromJSON jSON: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else {
            callback(nil)
            return
        }

        persistentStore?.localSubordinate(for: VehicleprofileArmor.self, pkCase: pkCase) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase)
            callback(newObject)
        }
    }

    public static func turret(fromJSON jSON: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let jSON = jSON as? JSON else {
            callback(nil)
            return
        }

        persistentStore?.localSubordinate(for: VehicleprofileArmor.self, pkCase: pkCase) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: jSON, pkCase: pkCase)
            callback(newObject)
        }
    }
}
