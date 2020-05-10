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
    override public func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //

        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        if let gun_id = self.gun_id {
            let gunJSONAdapter = VehicleprofileModule.GunJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: gun_id)
            let gunRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileGun.self, linkedObjectID: gun_id)
            let gunRequestPredicate = gunRequestComposer.build()?.requestPredicate
            let gunRequestParadigm = RequestParadigm(clazz: VehicleprofileGun.self, requestPredicate: gunRequestPredicate, keypathPrefix: "gun.")
            mappingCoordinator?.fetchRemote(paradigm: gunRequestParadigm, linker: gunJSONAdapter)
        }

        if let radio_id = self.radio_id {
            let radioJSONAdapter = VehicleprofileModule.RadioJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: radio_id)
            let radioRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileRadio.self, linkedObjectID: radio_id)
            let radioRequestPredicate = radioRequestComposer.build()?.requestPredicate
            let radioRequestParadigm = RequestParadigm(clazz: VehicleprofileRadio.self, requestPredicate: radioRequestPredicate, keypathPrefix: "radio.")
            mappingCoordinator?.fetchRemote(paradigm: radioRequestParadigm, linker: radioJSONAdapter)
        }

        if let engine_id = self.engine_id {
            let engineJSONAdapter = VehicleprofileModule.EngineJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: engine_id)
            let engineRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileEngine.self, linkedObjectID: engine_id)
            let engineRequestPredicate = engineRequestComposer.build()?.requestPredicate
            let engineReqestParadigm = RequestParadigm(clazz: VehicleprofileEngine.self, requestPredicate: engineRequestPredicate, keypathPrefix: "engine.")
            mappingCoordinator?.fetchRemote(paradigm: engineReqestParadigm, linker: engineJSONAdapter)
        }

        if let suspension_id = self.suspension_id {
            let suspensionJSONAdapter = VehicleprofileModule.SuspensionJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: suspension_id)
            let suspensionRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: suspension_id)
            let suspensionRequestPredicate = suspensionRequestComposer.build()?.requestPredicate
            let suspensionRequestParadigm = RequestParadigm(clazz: VehicleprofileSuspension.self, requestPredicate: suspensionRequestPredicate, keypathPrefix: "suspension.")
            mappingCoordinator?.fetchRemote(paradigm: suspensionRequestParadigm, linker: suspensionJSONAdapter)
        }

        if let turret_id = self.turret_id {
            let turretJSONAdapter = VehicleprofileModule.TurretJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: turret_id)
            let turretRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileTurret.self, linkedObjectID: turret_id)
            let turretRequestPredicate = turretRequestComposer.build()?.requestPredicate
            let turretRequestParadigm = RequestParadigm(clazz: VehicleprofileTurret.self, requestPredicate: turretRequestPredicate, keypathPrefix: "turret.")
            mappingCoordinator?.fetchRemote(paradigm: turretRequestParadigm, linker: turretJSONAdapter)
        }
    }
}

extension VehicleprofileModule {
    public class SuspensionJSONAdapterHelper: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["suspension"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["engine"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["turret"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["radio"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
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
