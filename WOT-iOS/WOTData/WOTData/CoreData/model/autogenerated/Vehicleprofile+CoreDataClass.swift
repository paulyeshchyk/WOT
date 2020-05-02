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

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(Vehicleprofile.hashName)
        case .internal: return #keyPath(Vehicleprofile.hashName)
        }
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
            let instanceHelper = VehicleProfileAmmoListLocalJSONAdapterHelper(vehicleProfile: self)
            persistentStore?.itemMapping(context: context, forClass: VehicleprofileAmmoList.self, items: itemsList, pkCase: itemCase, instanceHelper: instanceHelper, callback: { _ in })
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.armor)] as? JSON {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmorList.vehicleprofile))
            let instanceHelper = VehicleProfileArmorListLocalJSONAdapterHelper(vehicleProfile: self)
            persistentStore?.itemMapping(context: context, forClass: VehicleprofileArmorList.self, itemJSON: itemJSON, pkCase: itemCase, instanceHelper: instanceHelper, callback: { _ in })
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.suspension)] as? JSON {
            if let itemID = itemJSON[VehicleprofileSuspension.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileSuspension.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleProfileSuspensionLocalJSONAdapterHelper(vehicleProfile: self, tag: itemID)
                persistentStore?.itemMapping(context: context, forClass: VehicleprofileSuspension.self, itemJSON: itemJSON, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in })
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.gun)] as? JSON {
            if let itemID = itemJSON[VehicleprofileGun.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileGun.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleProfileModuleGunLocalJSONAdapterHelper(vehicleProfile: self, tag: itemID)
                persistentStore?.itemMapping(context: context, forClass: VehicleprofileGun.self, itemJSON: itemJSON, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in })
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.radio)] as? JSON {
            if let itemID = itemJSON[VehicleprofileRadio.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileRadio.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleProfileRadioLocalJSONAdapterHelper(vehicleProfile: self, tag: itemID)
                persistentStore?.itemMapping(context: context, forClass: VehicleprofileRadio.self, itemJSON: itemJSON, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in})
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.engine)] as? JSON {
            if let itemID = itemJSON[VehicleprofileEngine.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileEngine.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleProfileEngineLocalJSONAdapterHelper(vehicleProfile: self, tag: itemID)
                persistentStore?.itemMapping(context: context, forClass: VehicleprofileEngine.self, itemJSON: itemJSON, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in})
            }
        }

        if let itemJSON = jSON[#keyPath(Vehicleprofile.turret)] as? JSON {
            if let itemID = itemJSON[VehicleprofileTurret.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileTurret.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleProfileTurretLocalJSONAdapterHelper(vehicleProfile: self, tag: itemID)
                persistentStore?.itemMapping(context: context, forClass: VehicleprofileTurret.self, itemJSON: itemJSON, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in})
            }
        }

        if let moduleJSON = jSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            let vehicleprofileModuleCase = PKCase(parentObjects: parents)
            vehicleprofileModuleCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleprofile))
            let instanceHelper = VehicleProfileModuleJSONAdapterHelper(vehicleProfile: self)
            persistentStore?.itemMapping(context: context, forClass: VehicleprofileModule.self, itemJSON: moduleJSON, pkCase: vehicleprofileModuleCase, instanceHelper: instanceHelper, callback: { _ in })
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
