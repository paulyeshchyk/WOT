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
        /*
         if let gun_id = self.gun_id {
             let gunCase = PKCase()
             gunCase[.primary] = VehicleprofileGun.primaryKey(for: gun_id, andType: .external)
             gunCase[.secondary] = pkCase[.primary]
             let moduleGunHelper = VehicleprofileModule.GunJSONAdapterHelper(objectID: self.objectID, identifier: gun_id, persistentStore: persistentStore)
             persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileGun.self, pkCase: gunCase, keypathPrefix: "gun.", instanceHelper: moduleGunHelper)
         }

         if let radio_id = self.radio_id {
             let radioCase = PKCase()
             radioCase[.primary] = VehicleprofileRadio.primaryKey(for: radio_id, andType: .external)
             radioCase[.secondary] = pkCase[.primary]
             let moduleRadioHelper = VehicleprofileModule.RadioJSONAdapterHelper(objectID: self.objectID, identifier: radio_id, persistentStore: persistentStore)
             persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileRadio.self, pkCase: radioCase, keypathPrefix: "radio.", instanceHelper: moduleRadioHelper)
         }

         if let engine_id = self.engine_id {
             let engineCase = PKCase()
             engineCase[.primary] = VehicleprofileEngine.primaryKey(for: engine_id, andType: .external)
             engineCase[.secondary] = pkCase[.primary]
             let moduleEngineHelper = VehicleprofileModule.EngineJSONAdapterHelper(objectID: self.objectID, identifier: engine_id, persistentStore: persistentStore)
             persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileEngine.self, pkCase: engineCase, keypathPrefix: "engine.", instanceHelper: moduleEngineHelper)
         }

         if let suspension_id = self.suspension_id {
             let suspensionCase = PKCase()
             suspensionCase[.primary] = VehicleprofileSuspension.primaryKey(for: suspension_id, andType: .external)
             suspensionCase[.secondary] = pkCase[.primary]
             let moduleSuspensionHelper = VehicleprofileModule.SuspensionJSONAdapterHelper(objectID: self.objectID, identifier: suspension_id, persistentStore: persistentStore)
             persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileSuspension.self, pkCase: suspensionCase, keypathPrefix: "suspension.", instanceHelper: moduleSuspensionHelper)
         }

         if let turret_id = self.turret_id {
             let turretCase = PKCase()
             turretCase[.primary] = VehicleprofileTurret.primaryKey(for: turret_id, andType: .external)
             turretCase[.secondary] = pkCase[.primary]
             let moduleTurretHelper = VehicleprofileModule.TurretJSONAdapterHelper(objectID: self.objectID, identifier: turret_id, persistentStore: persistentStore)
             persistentStore?.fetchRemote(context: context, byModelClass: VehicleprofileTurret.self, pkCase: turretCase, keypathPrefix: "turret.", instanceHelper: moduleTurretHelper)
         }
         */
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

extension VehicleprofileModule {
    //
    public class LocalJSONAdapterHelper: JSONAdapterInstanceHelper {
        var persistentStore: WOTPersistentStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, persistentStore: WOTPersistentStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.persistentStore = persistentStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let modules = fetchResult.managedObject() as? VehicleprofileModule {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.modules = modules
                    persistentStore?.stash(context: context, hint: nil) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class SuspensionJSONAdapterHelper: JSONAdapterInstanceHelper {
        var persistentStore: WOTPersistentStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, persistentStore: WOTPersistentStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.persistentStore = persistentStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["suspension"] as? JSON
        }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileSuspension.suspension_id = identifier as? NSDecimalNumber
                    module.vehicleChassis = vehicleProfileSuspension
                    persistentStore?.stash(context: context, hint: nil) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class EngineJSONAdapterHelper: JSONAdapterInstanceHelper {
        var persistentStore: WOTPersistentStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, persistentStore: WOTPersistentStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.persistentStore = persistentStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["engine"] as? JSON
        }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileEngine.engine_id = identifier as? NSDecimalNumber
                    module.vehicleEngine = vehicleProfileEngine
                    persistentStore?.stash(context: context, hint: nil) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class TurretJSONAdapterHelper: JSONAdapterInstanceHelper {
        var persistentStore: WOTPersistentStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, persistentStore: WOTPersistentStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.persistentStore = persistentStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["turret"] as? JSON
        }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileTurret.turret_id = identifier as? NSDecimalNumber
                    module.vehicleTurret = vehicleProfileTurret
                    persistentStore?.stash(context: context, hint: nil) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class RadioJSONAdapterHelper: JSONAdapterInstanceHelper {
        var persistentStore: WOTPersistentStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, persistentStore: WOTPersistentStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.persistentStore = persistentStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["radio"] as? JSON
        }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileRadio.radio_id = identifier as? NSDecimalNumber
                    module.vehicleRadio = vehicleProfileRadio
                    persistentStore?.stash(context: context, hint: nil) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class GunJSONAdapterHelper: JSONAdapterInstanceHelper {
        var persistentStore: WOTPersistentStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, persistentStore: WOTPersistentStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.persistentStore = persistentStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["gun"] as? JSON
        }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileGun.gun_id = identifier as? NSDecimalNumber
                    module.vehicleGun = vehicleProfileGun
                    persistentStore?.stash(context: context, hint: nil) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }
}
