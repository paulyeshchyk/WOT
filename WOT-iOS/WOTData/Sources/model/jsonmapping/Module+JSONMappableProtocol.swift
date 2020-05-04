//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension Module {
    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)

        let parents = pkCase.plainParents.filter({$0 is Vehicles}).compactMap({ $0.tank_id as? NSDecimalNumber })

        guard let module_id = self.module_id else {
            print("module_id not found")
            return
        }

        guard let moduleTypeString = self.type else {
            print("unknown module type")
            return
        }
        let moduleType = VehicleModuleType(rawValue: moduleTypeString)

        let tank_id = parents.first

        switch moduleType {
        case .vehicleChassis:
            let vehicleSuspensionLinker = Module.ModuleSuspensionLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileSuspension.self, context: context, persistentStore: mappingCoordinator, keyPathPrefix: "suspension.", linker: vehicleSuspensionLinker)
        case .vehicleGun:
            let vehicleGunLinker = Module.ModuleGunLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileGun.self, context: context, persistentStore: mappingCoordinator, keyPathPrefix: "gun.", linker: vehicleGunLinker)
        case .vehicleRadio:
            let vehicleRadioLinker = Module.ModuleRadioLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileRadio.self, context: context, persistentStore: mappingCoordinator, keyPathPrefix: "radio.", linker: vehicleRadioLinker)
        case .vehicleEngine:
            let vehicleEngineLinker = Module.ModuleEngineLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileEngine.self, context: context, persistentStore: mappingCoordinator, keyPathPrefix: "engine.", linker: vehicleEngineLinker)
        case .vehicleTurret:
            let vehicleTurretLinker = Module.ModuleTurretLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileTurret.self, context: context, persistentStore: mappingCoordinator, keyPathPrefix: "turret.", linker: vehicleTurretLinker)
        case .none, .tank, .unknown:
            fatalError("unknown module type")
        }
    }

    private func fetchRemoteModule(by module_id: NSDecimalNumber, tank_id: NSDecimalNumber?, andClass modelClazz: NSManagedObject.Type, context: NSManagedObjectContext, persistentStore: WOTMappingCoordinatorProtocol?, keyPathPrefix: String?, linker: JSONAdapterLinkerProtocol?) {
        let pkCase = PKCase()
        pkCase[.primary] = modelClazz.primaryKey(for: module_id, andType: .external)
        if let tank_id = tank_id {
            pkCase[.secondary] = Vehicles.primaryKey(for: tank_id, andType: .internal)
        }

        persistentStore?.fetchRemote(context: context, byModelClass: modelClazz, pkCase: pkCase, keypathPrefix: keyPathPrefix, linker: linker)
    }
}

extension Module {
    public class ModuleEngineLinker: JSONAdapterLinkerProtocol {
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
            return json["engine"] as? JSON
        }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let module = fetchResult.context.object(with: objectID) as? Module {
                    vehicleProfileEngine.engine_id = identifier as? NSDecimalNumber
                    module.engine = vehicleProfileEngine
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleTurretLinker: JSONAdapterLinkerProtocol {
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
            return json["turret"] as? JSON
        }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let module = context.object(with: objectID) as? Module {
                    vehicleProfileTurret.turret_id = identifier as? NSDecimalNumber
                    module.turret = vehicleProfileTurret
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleSuspensionLinker: JSONAdapterLinkerProtocol {
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
            return json["suspension"] as? JSON
        }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let module = context.object(with: objectID) as? Module {
                    vehicleProfileSuspension.suspension_id = identifier as? NSDecimalNumber
                    module.suspension = vehicleProfileSuspension
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleRadioLinker: JSONAdapterLinkerProtocol {
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
            return json["radio"] as? JSON
        }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let module = context.object(with: objectID) as? Module {
                    vehicleProfileRadio.radio_id = identifier as? NSDecimalNumber
                    module.radio = vehicleProfileRadio
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleGunLinker: JSONAdapterLinkerProtocol {
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

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
                if let module = context.object(with: objectID) as? Module {
                    vehicleProfileGun.gun_id = identifier as? NSDecimalNumber
                    module.gun = vehicleProfileGun
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
