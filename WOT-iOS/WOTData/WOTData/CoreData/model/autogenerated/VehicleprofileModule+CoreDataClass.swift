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
    override public func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)

        let gunCase = PKCase()
        gunCase[.primary] = VehicleprofileGun.primaryIdKey(for: self.gun_id)
        gunCase[.secondary] = pkCase[.primary]
        persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileGun.self, pkCase: gunCase, keypathPrefix: "gun.", onObjectDidFetch: { (context, managedObjectID, _) in
            if let managedObjectID = managedObjectID, let gun = context.object(with: managedObjectID) as? VehicleprofileGun {
                self.vehicleGun = gun
                persistentStore?.stash(context: context, hint: gunCase)
            }
        })

        let radioCase = PKCase()
        radioCase[.primary] = VehicleprofileRadio.primaryIdKey(for: self.radio_id)
        radioCase[.secondary] = pkCase[.primary]
        persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileRadio.self, pkCase: radioCase, keypathPrefix: "radio.", onObjectDidFetch: { (context, managedObjectID, _) in
            if let managedObjectID = managedObjectID, let radio = context.object(with: managedObjectID) as? VehicleprofileRadio {
                self.vehicleRadio = radio
                persistentStore?.stash(context: context,hint: radioCase)
            }
        })
        let engineCase = PKCase()
        engineCase[.primary] = VehicleprofileEngine.primaryIdKey(for: self.engine_id)
        engineCase[.secondary] = pkCase[.primary]
        persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileEngine.self, pkCase: engineCase, keypathPrefix: "engine.", onObjectDidFetch: { (context, managedObjectID, _) in
            if let managedObjectID = managedObjectID, let engine = context.object(with: managedObjectID) as? VehicleprofileEngine {
                self.vehicleEngine = engine
                persistentStore?.stash(context: context, hint: engineCase)
            }
        })
        let suspensionCase = PKCase()
        suspensionCase[.primary] = VehicleprofileSuspension.primaryIdKey(for: self.suspension_id)
        suspensionCase[.secondary] = pkCase[.primary]
        persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileSuspension.self, pkCase: suspensionCase, keypathPrefix: "suspension.", onObjectDidFetch: { (context, managedObjectID, _) in
            if let managedObjectID = managedObjectID, let suspension = context.object(with: managedObjectID) as? VehicleprofileSuspension {
                self.vehicleChassis = suspension
                persistentStore?.stash(context: context, hint: suspensionCase)
            }
        })

        //turret is optional device, turret_id can be null
        if let turret_id = self.turret_id {
            let turretCase = PKCase()
            turretCase[.primary] = VehicleprofileTurret.primaryIdKey(for: turret_id)
            turretCase[.secondary] = pkCase[.primary]
            persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileTurret.self, pkCase: turretCase, keypathPrefix: "turret.", onObjectDidFetch: { (context, managedObjectID, _) in
                if let managedObjectID = managedObjectID, let turret = context.object(with: managedObjectID) as? VehicleprofileTurret {
                    self.vehicleTurret = turret
                    persistentStore?.stash(context: context, hint: turretCase)
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
