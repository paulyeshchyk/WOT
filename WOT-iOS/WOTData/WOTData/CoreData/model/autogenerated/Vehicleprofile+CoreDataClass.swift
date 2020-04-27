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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }
        var parents = pkCase.plainParents
        parents.append(self)

        if let itemsList = jSON[#keyPath(Vehicleprofile.ammo)] as? [Any] {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoList.vehicleprofile))
            persistentStore?.itemMapping(forClass: VehicleprofileAmmoList.self, items: itemsList, pkCase: itemCase) { newObject in
                self.ammo = newObject as? VehicleprofileAmmoList
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.armor)] as? JSON {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmorList.vehicleprofile))
            persistentStore?.itemMapping(forClass: VehicleprofileArmorList.self, itemJSON: itemJSON, pkCase: itemCase) { newObject in
                self.armor = newObject as? VehicleprofileArmorList
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.engine)] as? JSON {
            if let itemID = itemJSON[VehicleprofileEngine.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileEngine.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileEngine.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.engine = newObject as? VehicleprofileEngine
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.gun)] as? JSON {
            if let itemID = itemJSON[VehicleprofileGun.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileGun.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileGun.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.gun = newObject as? VehicleprofileGun
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.radio)] as? JSON {
            if let itemID = itemJSON[VehicleprofileRadio.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileRadio.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileRadio.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.radio = newObject as? VehicleprofileRadio
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.suspension)] as? JSON {
            if let itemID = itemJSON[VehicleprofileSuspension.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileSuspension.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileSuspension.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.suspension = newObject as? VehicleprofileSuspension
                }
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.turret)] as? JSON {
            if let itemID = itemJSON[VehicleprofileTurret.primaryKeyPath()] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileTurret.primaryKey(for: itemID)
                persistentStore?.itemMapping(forClass: VehicleprofileTurret.self, itemJSON: itemJSON, pkCase: pkCase) { newObject in
                    self.turret = newObject as? VehicleprofileTurret
                }
            }
        }

        if let moduleJSON = jSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            let vehicleprofileModuleCase = PKCase(parentObjects: parents)
            vehicleprofileModuleCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleprofile))
            persistentStore?.itemMapping(forClass: VehicleprofileModule.self, itemJSON: moduleJSON, pkCase: vehicleprofileModuleCase) { newObject in
                self.modules = newObject as? VehicleprofileModule
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
