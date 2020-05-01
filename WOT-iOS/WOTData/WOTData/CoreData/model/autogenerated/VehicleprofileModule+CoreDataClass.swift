//
//  VehicleprofileModule+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData
import Foundation

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

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(VehicleprofileModule.module_id)
        case .internal: return #keyPath(VehicleprofileModule.module_id)
        }
    }
}

// MARK: - Mapping

extension VehicleprofileModule {
    override public func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        //
        try self.decode(json: jSON)

        if let gun_id = self.gun_id {
//            let gunCase = PKCase()
//            gunCase[.primary] = VehicleprofileGun.primaryKey(for: gun_id, andType: .external)
//            gunCase[.secondary] = pkCase[.primary]
//            persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileGun.self, pkCase: gunCase, keypathPrefix: "gun.", onObjectDidFetch: { fetchResult in
//
//                let context = fetchResult.context
//                if let gun = fetchResult.managedObject() as? VehicleprofileGun {
//                    self.vehicleGun = gun
//                    // gun.gun_id = gun_id // hack
//                    persistentStore?.stash(context: context, hint: gunCase) { error in
//                        if let error = error {
//                            print(error.debugDescription)
//                        }
//                    }
//                }
//            })
        }

        if let radio_id = self.radio_id {
//            let radioCase = PKCase()
//            radioCase[.primary] = VehicleprofileRadio.primaryKey(for: radio_id, andType: .external)
//            radioCase[.secondary] = pkCase[.primary]
//            persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileRadio.self, pkCase: radioCase, keypathPrefix: "radio.", onObjectDidFetch: { fetchResult in
//
//                let context = fetchResult.context
//                if let radio = fetchResult.managedObject() as? VehicleprofileRadio {
//                    self.vehicleRadio = radio
//                    // radio.radio_id = radio_id // hack
//                    persistentStore?.stash(context: context, hint: radioCase) { error in
//                        if let error = error {
//                            print(error.debugDescription)
//                        }
//                    }
//                }
//            })
        }

        if let engine_id = self.engine_id {
//            let engineCase = PKCase()
//            engineCase[.primary] = VehicleprofileEngine.primaryKey(for: engine_id, andType: .external)
//            engineCase[.secondary] = pkCase[.primary]
//            persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileEngine.self, pkCase: engineCase, keypathPrefix: "engine.", onObjectDidFetch: { fetchResult in
//                let context = fetchResult.context
//                if let engine = fetchResult.managedObject() as? VehicleprofileEngine {
//                    self.vehicleEngine = engine
//                    // engine.engine_id = engine_id //hack
//                    persistentStore?.stash(context: context, hint: engineCase) { error in
//                        if let error = error {
//                            print(error.debugDescription)
//                        }
//                    }
//                }
//            })
        }

        if let suspension_id = self.suspension_id {
//            let suspensionCase = PKCase()
//            suspensionCase[.primary] = VehicleprofileSuspension.primaryKey(for: suspension_id, andType: .external)
//            suspensionCase[.secondary] = pkCase[.primary]
//            persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileSuspension.self, pkCase: suspensionCase, keypathPrefix: "suspension.", onObjectDidFetch: { fetchResult in
//                let context = fetchResult.context
//                if let suspension = fetchResult.managedObject() as? VehicleprofileSuspension {
//                    self.vehicleChassis = suspension
//                    // suspension.suspension_id = suspension_id //hack
//                    persistentStore?.stash(context: context, hint: suspensionCase) { error in
//                        if let error = error {
//                            print(error.debugDescription)
//                        }
//                    }
//                }
//            })
        }

        if let turret_id = self.turret_id {
//            let turretCase = PKCase()
//            turretCase[.primary] = VehicleprofileTurret.primaryKey(for: turret_id, andType: .external)
//            turretCase[.secondary] = pkCase[.primary]
//            persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileTurret.self, pkCase: turretCase, keypathPrefix: "turret.", onObjectDidFetch: { fetchResult in
//                let context = fetchResult.context
//                if let turret = fetchResult.managedObject() as? VehicleprofileTurret {
//                    self.vehicleTurret = turret
//                    // turret.turret_id = turret_id //hack
//                    persistentStore?.stash(context: context, hint: turretCase) { error in
//                        if let error = error {
//                            print(error.debugDescription)
//                        }
//                    }
//                }
//            })
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
