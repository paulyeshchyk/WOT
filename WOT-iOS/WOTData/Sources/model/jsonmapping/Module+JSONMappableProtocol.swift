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
    override public func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)

        let parentsAsManagedObject = requestPredicate.parentObjectIDList.compactMap { context.object(with: $0) }
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

        let moduleType = VehicleModuleType.fromString(self.type)
        switch moduleType {
        case .vehicleChassis:
            let chassisJSONAdapter = Module.SuspensionMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let chassisRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: module_id)
            let chassisRequestParadigm = RequestParadigm(clazz: VehicleprofileSuspension.self, adapter: chassisJSONAdapter, requestPredicateComposer: chassisRequestComposer, keypathPrefix: "suspension.")
            mappingCoordinator?.fetchRemote(paradigm: chassisRequestParadigm)
        case .vehicleGun:
            #warning("has errors")
            let gunJSONAdapter = Module.GunMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let gunRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileGun.self, linkedObjectID: module_id)
            let gunRequestParadigm = RequestParadigm(clazz: VehicleprofileGun.self, adapter: gunJSONAdapter, requestPredicateComposer: gunRequestComposer, keypathPrefix: "gun.")
            mappingCoordinator?.fetchRemote(paradigm: gunRequestParadigm)
        case .vehicleRadio:
            let radioJSONAdapter = Module.RadioMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let radioRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileRadio.self, linkedObjectID: module_id)
            let radioRequestParadigm = RequestParadigm(clazz: VehicleprofileRadio.self, adapter: radioJSONAdapter, requestPredicateComposer: radioRequestComposer, keypathPrefix: "radio.")
            mappingCoordinator?.fetchRemote(paradigm: radioRequestParadigm)
        case .vehicleEngine:
            let engineJSONAdapter = Module.EngineMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let engineRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileEngine.self, linkedObjectID: module_id)
            let engineRequestParadigm = RequestParadigm(clazz: VehicleprofileEngine.self, adapter: engineJSONAdapter, requestPredicateComposer: engineRequestComposer, keypathPrefix: "engine.")
            mappingCoordinator?.fetchRemote(paradigm: engineRequestParadigm)
        case .vehicleTurret:
            let turretJSONAdapter = Module.TurretMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let turretRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileTurret.self, linkedObjectID: module_id)
            let turretRequestParadigm = RequestParadigm(clazz: VehicleprofileTurret.self, adapter: turretJSONAdapter, requestPredicateComposer: turretRequestComposer, keypathPrefix: "turret.")
            mappingCoordinator?.fetchRemote(paradigm: turretRequestParadigm)
        default: fatalError("unknown module type")
        }
    }
}

extension Module {
    public class EngineMapper: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["engine"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["turret"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["suspension"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["radio"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["gun"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
