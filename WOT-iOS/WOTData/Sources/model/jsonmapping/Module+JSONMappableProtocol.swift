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
            let suspensionMapper = Module.SuspensionMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            let ruleBuilder = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: module_id)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileSuspension.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: ruleBuilder, keypathPrefix: "suspension.", mapper: suspensionMapper)
        case .vehicleGun:
            let gunMapper = Module.GunMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            let ruleBuilder = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileGun.self, linkedObjectID: module_id)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileGun.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: ruleBuilder, keypathPrefix: "gun.", mapper: gunMapper)
        case .vehicleRadio:
            let radioMapper = Module.RadioMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            let ruleBuilder = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileRadio.self, linkedObjectID: module_id)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileRadio.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: ruleBuilder, keypathPrefix: "radio.", mapper: radioMapper)
        case .vehicleEngine:
            let engineMapper = Module.EngineMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            let ruleBuilder = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileEngine.self, linkedObjectID: module_id)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileEngine.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: ruleBuilder, keypathPrefix: "engine.", mapper: engineMapper)
        case .vehicleTurret:
            let turretMapper = Module.TurretMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            let ruleBuilder = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileTurret.self, linkedObjectID: module_id)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileTurret.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: ruleBuilder, keypathPrefix: "turret.", mapper: turretMapper)
        case .none, .tank, .unknown:
            fatalError("unknown module type")
//        default: break
        }
    }
}

extension Module {
    public class EngineMapper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .local }

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
                    vehicleProfileEngine.engine_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.engine = vehicleProfileEngine
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class TurretMapper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .local }

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
                    vehicleProfileTurret.turret_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.turret = vehicleProfileTurret
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class SuspensionMapper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .local }

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
                    vehicleProfileSuspension.suspension_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.suspension = vehicleProfileSuspension
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class RadioMapper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .local }

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
                    vehicleProfileRadio.radio_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.radio = vehicleProfileRadio
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class GunMapper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .local }

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
                    vehicleProfileGun.gun_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.gun = vehicleProfileGun
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
