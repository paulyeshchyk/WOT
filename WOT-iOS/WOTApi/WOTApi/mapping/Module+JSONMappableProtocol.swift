//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol
extension Module: JSONDecodingProtocol {
    
    
}

extension Module {
    override public func mapping(json: JSON, objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, mappingCoordinator: MappingCoordinatorProtocol, requestManager: RequestManagerProtocol) throws {
        
        //
        try self.decode(json: json)
        //
        
        let parentsAsVehicles = requestPredicate.parentObjectIDList
            .compactMap { objectContext.object(byID: $0) as? Vehicles }
        let parents = parentsAsVehicles.compactMap { $0.tank_id }

        let masterFetchResult = FetchResult(objectContext: objectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

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
            let chassisRequestParadigm = MappingParadigm(clazz: VehicleprofileSuspension.self, adapter: chassisJSONAdapter, requestPredicateComposer: chassisRequestComposer, keypathPrefix: "suspension.")
            requestManager.fetchRemote(paradigm: chassisRequestParadigm)
        case .vehicleGun:
            let gunJSONAdapter = Module.GunMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let gunRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileGun.self, linkedObjectID: module_id)
            let gunRequestParadigm = MappingParadigm(clazz: VehicleprofileGun.self, adapter: gunJSONAdapter, requestPredicateComposer: gunRequestComposer, keypathPrefix: "gun.")
            requestManager.fetchRemote(paradigm: gunRequestParadigm)
        case .vehicleRadio:
            let radioJSONAdapter = Module.RadioMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let radioRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileRadio.self, linkedObjectID: module_id)
            let radioRequestParadigm = MappingParadigm(clazz: VehicleprofileRadio.self, adapter: radioJSONAdapter, requestPredicateComposer: radioRequestComposer, keypathPrefix: "radio.")
            requestManager.fetchRemote(paradigm: radioRequestParadigm)
        case .vehicleEngine:
            let engineJSONAdapter = Module.EngineMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let engineRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileEngine.self, linkedObjectID: module_id)
            let engineRequestParadigm = MappingParadigm(clazz: VehicleprofileEngine.self, adapter: engineJSONAdapter, requestPredicateComposer: engineRequestComposer, keypathPrefix: "engine.")
            requestManager.fetchRemote(paradigm: engineRequestParadigm)
        case .vehicleTurret:
            let turretJSONAdapter = Module.TurretMapper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let turretRequestComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileTurret.self, linkedObjectID: module_id)
            let turretRequestParadigm = MappingParadigm(clazz: VehicleprofileTurret.self, adapter: turretJSONAdapter, requestPredicateComposer: turretRequestComposer, keypathPrefix: "turret.")
            requestManager.fetchRemote(paradigm: turretRequestParadigm)
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Module.self))
                return
            }
            vehicleProfileEngine.engine_id = self.mappedObjectIdentifier as? NSDecimalNumber
            module.engine = vehicleProfileEngine
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                    vehicleProfileTurret.turret_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.turret = vehicleProfileTurret
                    dataStore?.stash(objectContext: managedObjectContext) { error in
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                    vehicleProfileSuspension.suspension_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.suspension = vehicleProfileSuspension
                    dataStore?.stash(objectContext: managedObjectContext) { error in
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                    vehicleProfileRadio.radio_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.radio = vehicleProfileRadio
                    dataStore?.stash(objectContext: managedObjectContext) { error in
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
                if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                    vehicleProfileGun.gun_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.gun = vehicleProfileGun
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
