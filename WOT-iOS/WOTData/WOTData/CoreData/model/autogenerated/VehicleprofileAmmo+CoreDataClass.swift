//
//  VehicleprofileAmmo+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileAmmo)
public class VehicleprofileAmmo: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileAmmo {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case type
        case stun
        case damage
        case penetration
    }

    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath() -> String {
        return #keyPath(VehicleprofileAmmo.type)
    }
}

// MARK: - Mapping
extension VehicleprofileAmmo {
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let vehicleprofileAmmoPenetrationCase = PKCase()
        vehicleprofileAmmoPenetrationCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        vehicleprofileAmmoPenetrationCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        VehicleprofileAmmoPenetration.penetration(fromArray: jSON[#keyPath(VehicleprofileAmmo.penetration)], pkCase: vehicleprofileAmmoPenetrationCase, persistentStore: persistentStore) { newObject in
            self.penetration = newObject as? VehicleprofileAmmoPenetration
            persistentStore?.stash(hint: vehicleprofileAmmoPenetrationCase)
        }

        let vehicleprofileAmmoDamageCase = PKCase()
        vehicleprofileAmmoDamageCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        vehicleprofileAmmoDamageCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        VehicleprofileAmmoDamage.damage(fromArray: jSON[#keyPath(VehicleprofileAmmo.damage)], pkCase: vehicleprofileAmmoDamageCase, persistentStore: persistentStore) { newObject in
            self.damage = newObject as? VehicleprofileAmmoDamage
            persistentStore?.stash(hint: vehicleprofileAmmoDamageCase)
        }
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, persistentStore: WOTPersistentStoreProtocol?) {
        guard let json = json, let entityDescription = VehicleprofileAmmo.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey

        persistentStore?.mapping(object: self, fromJSON: json, pkCase: pkCase)
    }
}

// MARK: - JSONDecoding
extension VehicleprofileAmmo: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }
}
