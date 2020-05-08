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

        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        if let gun_id = self.gun_id {
            let gunMapper = VehicleprofileModule.GunJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: gun_id, coreDataStore: mappingCoordinator?.coreDataStore)
            let linkLookupRuleBuilder = MasterAsSecondaryLinkedAsPrimaryRuleBuilder(pkCase: pkCase, linkedClazz: VehicleprofileGun.self, linkedObjectID: gun_id)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileGun.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: linkLookupRuleBuilder, keypathPrefix: "gun.", mapper: gunMapper)
        }

        if let radio_id = self.radio_id {
            let linkLookupRuleBuilder = MasterAsSecondaryLinkedAsPrimaryRuleBuilder(pkCase: pkCase, linkedClazz: VehicleprofileRadio.self, linkedObjectID: radio_id)
            let radioMapper = VehicleprofileModule.RadioJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: radio_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileRadio.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: linkLookupRuleBuilder, keypathPrefix: "radio.", mapper: radioMapper)
        }

        if let engine_id = self.engine_id {
            let linkLookupRuleBuilder = MasterAsSecondaryLinkedAsPrimaryRuleBuilder(pkCase: pkCase, linkedClazz: VehicleprofileEngine.self, linkedObjectID: engine_id)
            let engineMapper = VehicleprofileModule.EngineJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: engine_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileEngine.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: linkLookupRuleBuilder, keypathPrefix: "engine.", mapper: engineMapper)
        }

        if let suspension_id = self.suspension_id {
            let linkLookupRuleBuilder = MasterAsSecondaryLinkedAsPrimaryRuleBuilder(pkCase: pkCase, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: suspension_id)
            let suspensionMapper = VehicleprofileModule.SuspensionJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: suspension_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileSuspension.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: linkLookupRuleBuilder, keypathPrefix: "suspension.", mapper: suspensionMapper)
        }

        if let turret_id = self.turret_id {
            let linkLookupRuleBuilder = MasterAsSecondaryLinkedAsPrimaryRuleBuilder(pkCase: pkCase, linkedClazz: VehicleprofileTurret.self, linkedObjectID: turret_id)
            let turretMapper = VehicleprofileModule.TurretJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: turret_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.linkRemote(modelClazz: VehicleprofileTurret.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: linkLookupRuleBuilder, keypathPrefix: "turret.", mapper: turretMapper)
        }
    }
}

extension VehicleprofileModule {
    public class SuspensionJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["suspension"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule {
                    vehicleProfileSuspension.suspension_id = mappedObjectIdentifier as? NSDecimalNumber
                    module.vehicleChassis = vehicleProfileSuspension
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class EngineJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["engine"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule {
                    vehicleProfileEngine.engine_id = mappedObjectIdentifier as? NSDecimalNumber
                    module.vehicleEngine = vehicleProfileEngine
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class TurretJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["turret"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule {
                    vehicleProfileTurret.turret_id = mappedObjectIdentifier as? NSDecimalNumber
                    module.vehicleTurret = vehicleProfileTurret
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class RadioJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["radio"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule {
                    vehicleProfileRadio.radio_id = mappedObjectIdentifier as? NSDecimalNumber
                    module.vehicleRadio = vehicleProfileRadio
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class GunJSONAdapterHelper: BaseJSONAdapterLinker {
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
                if let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule {
                    vehicleProfileGun.gun_id = mappedObjectIdentifier as? NSDecimalNumber
                    module.vehicleGun = vehicleProfileGun
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
