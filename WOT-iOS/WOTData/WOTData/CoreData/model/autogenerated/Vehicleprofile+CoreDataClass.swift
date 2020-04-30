//
//  Vehicleprofile+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Vehicleprofile)
public class Vehicleprofile: NSManagedObject {}

// MARK: - Coding Keys
extension Vehicleprofile {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case max_ammo
        case weight
        case hp
        case is_default
        case hull_weight
        case speed_forward
        case hull_hp
        case speed_backward
        case tank_id
        case max_weight
    }

    public enum RelativeKeys: String, CodingKey, CaseIterable {
        case modules
        case modulesTree
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public static func relationsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath() -> String {
        return #keyPath(Vehicleprofile.hashName)
    }
}

// MARK: - Mapping
extension Vehicleprofile {
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)

        var parents = pkCase.plainParents
        parents.append(self)

        if let itemsList = jSON[#keyPath(Vehicleprofile.ammo)] as? [Any] {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoList.vehicleprofile))
            try? persistentStore?.itemMapping(context: context, forClass: VehicleprofileAmmoList.self, items: itemsList, pkCase: itemCase) { managedObjectID in
                guard let managedObjectID = managedObjectID, let ammo = context.object(with: managedObjectID) as? VehicleprofileAmmoList else {
                    return
                }
                self.ammo = ammo
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.armor)] as? JSON {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmorList.vehicleprofile))
            try? persistentStore?.itemMapping(context: context, forClass: VehicleprofileArmorList.self, itemJSON: itemJSON, pkCase: itemCase) { managedObjectID in
                guard let managedObjectID = managedObjectID, let armor = context.object(with: managedObjectID) as? VehicleprofileArmorList else {
                    return
                }
                self.armor = armor
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.engine)] as? JSON {
            if let itemID = itemJSON[VehicleprofileEngine.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileEngine.primaryKey(for: itemID)
                try? persistentStore?.itemMapping(context: context, forClass: VehicleprofileEngine.self, itemJSON: itemJSON, pkCase: pkCase) { managedObjectID in
                    guard let managedObjectID = managedObjectID, let engine = context.object(with: managedObjectID) as? VehicleprofileEngine else {
                        return
                    }
                    self.engine = engine
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.gun)] as? JSON {
            if let itemID = itemJSON[VehicleprofileGun.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileGun.primaryKey(for: itemID)
                try? persistentStore?.itemMapping(context: context, forClass: VehicleprofileGun.self, itemJSON: itemJSON, pkCase: pkCase) { managedObjectID in
                    guard let managedObjectID = managedObjectID, let gun = context.object(with: managedObjectID) as? VehicleprofileGun else {
                        return
                    }
                    self.gun = gun
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.radio)] as? JSON {
            if let itemID = itemJSON[VehicleprofileRadio.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileRadio.primaryKey(for: itemID)
                try? persistentStore?.itemMapping(context: context, forClass: VehicleprofileRadio.self, itemJSON: itemJSON, pkCase: pkCase) { managedObjectID in
                    guard let managedObjectID = managedObjectID, let radio = context.object(with: managedObjectID) as? VehicleprofileRadio else {
                        return
                    }
                    self.radio = radio
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.suspension)] as? JSON {
            if let itemID = itemJSON[VehicleprofileSuspension.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileSuspension.primaryKey(for: itemID)
                try? persistentStore?.itemMapping(context: context, forClass: VehicleprofileSuspension.self, itemJSON: itemJSON, pkCase: pkCase) { managedObjectID in
                    guard let managedObjectID = managedObjectID, let suspension = context.object(with: managedObjectID) as? VehicleprofileSuspension else {
                        return
                    }
                    self.suspension = suspension
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.turret)] as? JSON {
            if let itemID = itemJSON[VehicleprofileTurret.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileTurret.primaryKey(for: itemID)
                try? persistentStore?.itemMapping(context: context, forClass: VehicleprofileTurret.self, itemJSON: itemJSON, pkCase: pkCase) { managedObjectID in
                    guard let managedObjectID = managedObjectID, let turret = context.object(with: managedObjectID) as? VehicleprofileTurret else {
                        return
                    }
                    self.turret = turret
                }
            }
        }

        if let moduleJSON = jSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            let vehicleprofileModuleCase = PKCase(parentObjects: parents)
            vehicleprofileModuleCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleprofile))
            try? persistentStore?.itemMapping(context: context, forClass: VehicleprofileModule.self, itemJSON: moduleJSON, pkCase: vehicleprofileModuleCase) { managedObjectID in
                guard let managedObjectID = managedObjectID, let module = context.object(with: managedObjectID) as? VehicleprofileModule else {
                    return
                }
                self.modules = module
            }
        }
    }
}

// MARK: - JSONDecoding
extension Vehicleprofile: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.tank_id = try container.decodeAnyIfPresent(Int.self, forKey: .tank_id)?.asDecimal
        self.is_default = try container.decodeAnyIfPresent(Bool.self, forKey: .is_default)?.asDecimal
        self.max_ammo = try container.decodeAnyIfPresent(Int.self, forKey: .max_ammo)?.asDecimal
        self.max_weight = try container.decodeAnyIfPresent(Int.self, forKey: .max_weight)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.hp = try container.decodeAnyIfPresent(Int.self, forKey: .hp)?.asDecimal
        self.hull_hp = try container.decodeAnyIfPresent(Int.self, forKey: .hull_hp)?.asDecimal
        self.hull_weight = try container.decodeAnyIfPresent(Int.self, forKey: .hull_weight)?.asDecimal
        self.speed_backward = try container.decodeAnyIfPresent(Int.self, forKey: .speed_backward)?.asDecimal
        self.speed_forward = try container.decodeAnyIfPresent(Int.self, forKey: .speed_forward)?.asDecimal
    }
}
