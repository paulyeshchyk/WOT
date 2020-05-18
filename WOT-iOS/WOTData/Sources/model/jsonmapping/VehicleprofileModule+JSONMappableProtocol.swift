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
    override public func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol, requestManager: WOTRequestManagerProtocol) throws {
        //
        try self.decode(json: json)
        //

        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        if let gun_id = self.gun_id {
            let gunJSONAdapter = VehicleprofileModule.GunJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: gun_id)
            let gunRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileGun.self, linkedObjectID: gun_id)
            let gunRequestParadigm = RequestParadigm(clazz: VehicleprofileGun.self, adapter: gunJSONAdapter, requestPredicateComposer: gunRequestComposer, keypathPrefix: "gun.")
            requestManager.fetchRemote(paradigm: gunRequestParadigm)
        }

        if let radio_id = self.radio_id {
            let radioJSONAdapter = VehicleprofileModule.RadioJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: radio_id)
            let radioRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileRadio.self, linkedObjectID: radio_id)
            let radioRequestParadigm = RequestParadigm(clazz: VehicleprofileRadio.self, adapter: radioJSONAdapter, requestPredicateComposer: radioRequestComposer, keypathPrefix: "radio.")
            requestManager.fetchRemote(paradigm: radioRequestParadigm)
        }

        if let engine_id = self.engine_id {
            let engineJSONAdapter = VehicleprofileModule.EngineJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: engine_id)
            let engineRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileEngine.self, linkedObjectID: engine_id)
            let engineRequstParadigm = RequestParadigm(clazz: VehicleprofileEngine.self, adapter: engineJSONAdapter, requestPredicateComposer: engineRequestComposer, keypathPrefix: "engine.")
            requestManager.fetchRemote(paradigm: engineRequstParadigm)
        }

        if let suspension_id = self.suspension_id {
            let suspensionJSONAdapter = VehicleprofileModule.SuspensionJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: suspension_id)
            let suspensionRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: suspension_id)
            let suspensionRequestParadigm = RequestParadigm(clazz: VehicleprofileSuspension.self, adapter: suspensionJSONAdapter, requestPredicateComposer: suspensionRequestComposer, keypathPrefix: "suspension.")
            requestManager.fetchRemote(paradigm: suspensionRequestParadigm)
        }

        if let turret_id = self.turret_id {
            let turretJSONAdapter = VehicleprofileModule.TurretJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: turret_id)
            let turretRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: VehicleprofileTurret.self, linkedObjectID: turret_id)
            let turretRequestParadigm = RequestParadigm(clazz: VehicleprofileTurret.self, adapter: turretJSONAdapter, requestPredicateComposer: turretRequestComposer, keypathPrefix: "turret.")
            requestManager.fetchRemote(paradigm: turretRequestParadigm)
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
            guard let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileSuspension.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
                return
            }
            vehicleProfileSuspension.suspension_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleChassis = vehicleProfileSuspension
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
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
            guard let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
                return
            }
            vehicleProfileEngine.engine_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleEngine = vehicleProfileEngine
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
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
            guard let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileTurret.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileTurret.self))
                return
            }
            vehicleProfileTurret.turret_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleTurret = vehicleProfileTurret
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
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
            guard let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileRadio.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileRadio.self))
                return
            }
            vehicleProfileRadio.radio_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleRadio = vehicleProfileRadio
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
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
            guard let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileGun.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
                return
            }
            vehicleProfileGun.gun_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleGun = vehicleProfileGun
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
            }
        }
    }
}
