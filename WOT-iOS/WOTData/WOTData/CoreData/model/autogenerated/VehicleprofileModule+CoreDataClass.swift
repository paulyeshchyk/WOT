//
//  VehicleprofileModule+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileModule)
public class VehicleprofileModule: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileModule {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case radio_id
        case suspension_id
        case module_id
        case engine_id
        case gun_id
        case turret_id
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath() -> String {
        return #keyPath(VehicleprofileModule.module_id)
    }
}

// MARK: - Mapping
extension VehicleprofileModule {
    override public func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let gunCase = PKCase()
        gunCase[.primary] = VehicleprofileGun.primaryIdKey(for: self.gun_id)
        gunCase[.secondary] = pkCase[.primary]
        persistentStore?.remoteSubordinate(for: VehicleprofileGun.self, pkCase: gunCase, keypathPrefix: "gun.", onCreateNSManagedObject: { (managedObject) in
            if let gun = managedObject as? VehicleprofileGun {
                self.vehicleGun = gun
                persistentStore?.stash(hint: gunCase)
            }
        })

        let radioCase = PKCase()
        radioCase[.primary] = VehicleprofileRadio.primaryIdKey(for: self.radio_id)
        radioCase[.secondary] = pkCase[.primary]
        persistentStore?.remoteSubordinate(for: VehicleprofileRadio.self, pkCase: radioCase, keypathPrefix: "radio.", onCreateNSManagedObject: { (managedObject) in
            if let radio = managedObject as? VehicleprofileRadio {
                self.vehicleRadio = radio
                persistentStore?.stash(hint: radioCase)
            }
        })
        let engineCase = PKCase()
        engineCase[.primary] = VehicleprofileEngine.primaryIdKey(for: self.engine_id)
        engineCase[.secondary] = pkCase[.primary]
        persistentStore?.remoteSubordinate(for: VehicleprofileEngine.self, pkCase: engineCase, keypathPrefix: "engine.", onCreateNSManagedObject: { (managedObject) in
            if let engine = managedObject as? VehicleprofileEngine {
                self.vehicleEngine = engine
                persistentStore?.stash(hint: engineCase)
            }
        })
        let suspensionCase = PKCase()
        suspensionCase[.primary] = VehicleprofileSuspension.primaryIdKey(for: self.suspension_id)
        suspensionCase[.secondary] = pkCase[.primary]
        persistentStore?.remoteSubordinate(for: VehicleprofileSuspension.self, pkCase: suspensionCase, keypathPrefix: "suspension.", onCreateNSManagedObject: { (managedObject) in
            if let suspension = managedObject as? VehicleprofileSuspension {
                self.vehicleChassis = suspension
                persistentStore?.stash(hint: suspensionCase)
            }
        })

        //turret is optional device, turret_id can be null
        if let turret_id = self.turret_id {
            let turretCase = PKCase()
            turretCase[.primary] = VehicleprofileTurret.primaryIdKey(for: turret_id)
            turretCase[.secondary] = pkCase[.primary]
            persistentStore?.remoteSubordinate(for: VehicleprofileTurret.self, pkCase: turretCase, keypathPrefix: "turret.", onCreateNSManagedObject: { (managedObject) in
                if let turret = managedObject as? VehicleprofileTurret {
                    self.vehicleTurret = turret
                    persistentStore?.stash(hint: turretCase)
                }
            })
        }
    }
}

// MARK: - JSONDecoding
extension VehicleprofileModule: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.radio_id = try container.decodeAnyIfPresent(Int.self, forKey: .radio_id)?.asDecimal
        self.suspension_id = try container.decodeAnyIfPresent(Int.self, forKey: .suspension_id)?.asDecimal
        self.engine_id = try container.decodeAnyIfPresent(Int.self, forKey: .engine_id)?.asDecimal
        self.gun_id = try container.decodeAnyIfPresent(Int.self, forKey: .gun_id)?.asDecimal
        self.turret_id = try container.decodeAnyIfPresent(Int.self, forKey: .turret_id)?.asDecimal
    }
}
