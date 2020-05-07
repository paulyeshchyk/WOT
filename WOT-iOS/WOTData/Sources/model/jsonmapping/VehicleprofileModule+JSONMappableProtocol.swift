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
            let gunCase = PKCase()
            gunCase[.primary] = VehicleprofileGun.primaryKey(for: gun_id, andType: .external)
            gunCase[.secondary] = pkCase[.primary]
            let moduleGunHelper = VehicleprofileModule.GunJSONAdapterHelper(masterFetchResult: masterFetchResult, identifier: gun_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileGun.self, pkCase: gunCase, keypathPrefix: "gun.", linker: moduleGunHelper)
        }

        if let radio_id = self.radio_id {
            let radioCase = PKCase()
            radioCase[.primary] = VehicleprofileRadio.primaryKey(for: radio_id, andType: .external)
            radioCase[.secondary] = pkCase[.primary]
            let moduleRadioHelper = VehicleprofileModule.RadioJSONAdapterHelper(masterFetchResult: masterFetchResult, identifier: radio_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileRadio.self, pkCase: radioCase, keypathPrefix: "radio.", linker: moduleRadioHelper)
        }

        if let engine_id = self.engine_id {
            let engineCase = PKCase()
            engineCase[.primary] = VehicleprofileEngine.primaryKey(for: engine_id, andType: .external)
            engineCase[.secondary] = pkCase[.primary]
            let moduleEngineHelper = VehicleprofileModule.EngineJSONAdapterHelper(masterFetchResult: masterFetchResult, identifier: engine_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileEngine.self, pkCase: engineCase, keypathPrefix: "engine.", linker: moduleEngineHelper)
        }

        if let suspension_id = self.suspension_id {
            let suspensionCase = PKCase()
            suspensionCase[.primary] = VehicleprofileSuspension.primaryKey(for: suspension_id, andType: .external)
            suspensionCase[.secondary] = pkCase[.primary]
            let moduleSuspensionHelper = VehicleprofileModule.SuspensionJSONAdapterHelper(masterFetchResult: masterFetchResult, identifier: suspension_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileSuspension.self, pkCase: suspensionCase, keypathPrefix: "suspension.", linker: moduleSuspensionHelper)
        }

        if let turret_id = self.turret_id {
            let turretCase = PKCase()
            turretCase[.primary] = VehicleprofileTurret.primaryKey(for: turret_id, andType: .external)
            turretCase[.secondary] = pkCase[.primary]
            let moduleTurretHelper = VehicleprofileModule.TurretJSONAdapterHelper(masterFetchResult: masterFetchResult, identifier: turret_id, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: VehicleprofileTurret.self, pkCase: turretCase, keypathPrefix: "turret.", linker: moduleTurretHelper)
        }
    }
}

extension VehicleprofileModule {
    public class SuspensionJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
                    vehicleProfileSuspension.suspension_id = identifier as? NSDecimalNumber
                    module.vehicleChassis = vehicleProfileSuspension
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class EngineJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
                    vehicleProfileEngine.engine_id = identifier as? NSDecimalNumber
                    module.vehicleEngine = vehicleProfileEngine
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class TurretJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
                    vehicleProfileTurret.turret_id = identifier as? NSDecimalNumber
                    module.vehicleTurret = vehicleProfileTurret
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class RadioJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
                    vehicleProfileRadio.radio_id = identifier as? NSDecimalNumber
                    module.vehicleRadio = vehicleProfileRadio
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class GunJSONAdapterHelper: BaseJSONAdapterLinker {
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
                if let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule {
                    vehicleProfileGun.gun_id = identifier as? NSDecimalNumber
                    module.vehicleGun = vehicleProfileGun
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
