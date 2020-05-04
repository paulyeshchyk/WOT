//
//  VehicleprofileModule+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension VehicleprofileModule {
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        if let gun_id = self.gun_id {
            let gunCase = PKCase()
            gunCase[.primary] = VehicleprofileGun.primaryKey(for: gun_id, andType: .external)
            gunCase[.secondary] = pkCase[.primary]
            let moduleGunHelper = VehicleprofileModule.GunJSONAdapterHelper(objectID: self.objectID, identifier: gun_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileGun.self, pkCase: gunCase, keypathPrefix: "gun.", linker: moduleGunHelper)
        }

        if let radio_id = self.radio_id {
            let radioCase = PKCase()
            radioCase[.primary] = VehicleprofileRadio.primaryKey(for: radio_id, andType: .external)
            radioCase[.secondary] = pkCase[.primary]
            let moduleRadioHelper = VehicleprofileModule.RadioJSONAdapterHelper(objectID: self.objectID, identifier: radio_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileRadio.self, pkCase: radioCase, keypathPrefix: "radio.", linker: moduleRadioHelper)
        }

        if let engine_id = self.engine_id {
            let engineCase = PKCase()
            engineCase[.primary] = VehicleprofileEngine.primaryKey(for: engine_id, andType: .external)
            engineCase[.secondary] = pkCase[.primary]
            let moduleEngineHelper = VehicleprofileModule.EngineJSONAdapterHelper(objectID: self.objectID, identifier: engine_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileEngine.self, pkCase: engineCase, keypathPrefix: "engine.", linker: moduleEngineHelper)
        }

        if let suspension_id = self.suspension_id {
            let suspensionCase = PKCase()
            suspensionCase[.primary] = VehicleprofileSuspension.primaryKey(for: suspension_id, andType: .external)
            suspensionCase[.secondary] = pkCase[.primary]
            let moduleSuspensionHelper = VehicleprofileModule.SuspensionJSONAdapterHelper(objectID: self.objectID, identifier: suspension_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileSuspension.self, pkCase: suspensionCase, keypathPrefix: "suspension.", linker: moduleSuspensionHelper)
        }

        if let turret_id = self.turret_id {
            let turretCase = PKCase()
            turretCase[.primary] = VehicleprofileTurret.primaryKey(for: turret_id, andType: .external)
            turretCase[.secondary] = pkCase[.primary]
            let moduleTurretHelper = VehicleprofileModule.TurretJSONAdapterHelper(objectID: self.objectID, identifier: turret_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileTurret.self, pkCase: turretCase, keypathPrefix: "turret.", linker: moduleTurretHelper)
        }
    }
}

extension VehicleprofileModule {
    public class SuspensionJSONAdapterHelper: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["suspension"] as? JSON
        }

        public func process(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileSuspension.suspension_id = identifier as? NSDecimalNumber
                    module.vehicleChassis = vehicleProfileSuspension
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class EngineJSONAdapterHelper: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["engine"] as? JSON
        }

        public func process(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileEngine.engine_id = identifier as? NSDecimalNumber
                    module.vehicleEngine = vehicleProfileEngine
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class TurretJSONAdapterHelper: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["turret"] as? JSON
        }

        public func process(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileTurret.turret_id = identifier as? NSDecimalNumber
                    module.vehicleTurret = vehicleProfileTurret
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class RadioJSONAdapterHelper: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["radio"] as? JSON
        }

        public func process(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileRadio.radio_id = identifier as? NSDecimalNumber
                    module.vehicleRadio = vehicleProfileRadio
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class GunJSONAdapterHelper: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .internal
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? {
            return json["gun"] as? JSON
        }

        public func process(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
                if let module = context.object(with: objectID) as? VehicleprofileModule {
                    vehicleProfileGun.gun_id = identifier as? NSDecimalNumber
                    module.vehicleGun = vehicleProfileGun
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }
}
