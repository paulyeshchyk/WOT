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
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)

        let parentsAsManagedObject = pkCase.parentObjectIDList.compactMap { context.object(with: $0) }
        let parentsAsVehicles = parentsAsManagedObject.compactMap { $0 as? Vehicles }
        let parents = parentsAsVehicles.compactMap { $0.tank_id }

        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        guard parents.count <= 1 else {
            print("parents count should be less or equal 1")
            return
        }
        let tank_id = parents.first

        guard let module_id = self.module_id else {
            print("module_id not found")
            return
        }

        guard let moduleTypeString = self.type else {
            print("unknown module type")
            return
        }

        let moduleType = VehicleModuleType(rawValue: moduleTypeString)
        switch moduleType {
        case .vehicleChassis:
            let vehicleSuspensionLinker = Module.SuspensionLinker(masterFetchResult: masterFetchResult, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            self.fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileSuspension.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "suspension.", linker: vehicleSuspensionLinker)
        case .vehicleGun:
            let vehicleGunLinker = Module.ModuleGunLinker(masterFetchResult: masterFetchResult, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            self.fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileGun.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "gun.", linker: vehicleGunLinker)
        case .vehicleRadio:
            let vehicleRadioLinker = Module.RadioLinker(masterFetchResult: masterFetchResult, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            self.fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileRadio.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "radio.", linker: vehicleRadioLinker)
        case .vehicleEngine:
            let vehicleEngineLinker = Module.EngineLinker(masterFetchResult: masterFetchResult, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            self.fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileEngine.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "engine.", linker: vehicleEngineLinker)
        case .vehicleTurret:
            let vehicleTurretLinker = Module.TurretLinker(masterFetchResult: masterFetchResult, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            self.fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileTurret.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "turret.", linker: vehicleTurretLinker)
        case .none, .tank, .unknown:
            fatalError("unknown module type")
        }
    }

    private func fetchRemoteModule(by module_id: NSDecimalNumber, tank_id: NSDecimalNumber?, andClass modelClazz: NSManagedObject.Type, context: NSManagedObjectContext, mappingCoordinator: WOTMappingCoordinatorProtocol?, keyPathPrefix: String?, linker: JSONAdapterLinkerProtocol) {
        let pkCase = PKCase()
        pkCase[.primary] = modelClazz.primaryKey(for: module_id, andType: .external)
        if let tank_id = tank_id {
            pkCase[.secondary] = Vehicles.primaryKey(for: tank_id, andType: .internal)
        }

        mappingCoordinator?.fetchRemote(context: context, byModelClass: modelClazz, pkCase: pkCase, keypathPrefix: keyPathPrefix, linker: linker)
    }
}

extension Module {
    public class EngineLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["engine"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let module = masterFetchResult?.managedObject(inContext: context) as? Module {
                    vehicleProfileEngine.engine_id = self.identifier as? NSDecimalNumber
                    module.engine = vehicleProfileEngine
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class TurretLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["turret"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let module = masterFetchResult?.managedObject(inContext: context) as? Module {
                    vehicleProfileTurret.turret_id = self.identifier as? NSDecimalNumber
                    module.turret = vehicleProfileTurret
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class SuspensionLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["suspension"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let module = masterFetchResult?.managedObject(inContext: context) as? Module {
                    vehicleProfileSuspension.suspension_id = self.identifier as? NSDecimalNumber
                    module.suspension = vehicleProfileSuspension
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class RadioLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["radio"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let module = masterFetchResult?.managedObject(inContext: context) as? Module {
                    vehicleProfileRadio.radio_id = self.identifier as? NSDecimalNumber
                    module.radio = vehicleProfileRadio
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleGunLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["gun"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
                if let module = masterFetchResult?.managedObject(inContext: context) as? Module {
                    vehicleProfileGun.gun_id = self.identifier as? NSDecimalNumber
                    module.gun = vehicleProfileGun
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
