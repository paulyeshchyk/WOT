//
//  VehicleprofileModule+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension VehicleprofileModule {
    override public func mapping(jsonmap: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        //
        try self.decode(decoderContainer: jsonmap.json)
        //

        let masterFetchResult = FetchResult(objectContext: jsonmap.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        if let gun_id = self.gun_id {
            let gunJSONAdapter = VehicleprofileModule.GunJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: gun_id)
            let gunRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: jsonmap.predicate, linkedClazz: VehicleprofileGun.self, linkedObjectID: gun_id)
            let gunRequestParadigm = MappingParadigm(clazz: VehicleprofileGun.self, adapter: gunJSONAdapter, requestPredicateComposer: gunRequestComposer, keypathPrefix: "gun.")
            inContext.requestManager?.fetchRemote(paradigm: gunRequestParadigm)
        }

        if let radio_id = self.radio_id {
            let radioJSONAdapter = VehicleprofileModule.RadioJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: radio_id)
            let radioRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: jsonmap.predicate, linkedClazz: VehicleprofileRadio.self, linkedObjectID: radio_id)
            let radioRequestParadigm = MappingParadigm(clazz: VehicleprofileRadio.self, adapter: radioJSONAdapter, requestPredicateComposer: radioRequestComposer, keypathPrefix: "radio.")
            inContext.requestManager?.fetchRemote(paradigm: radioRequestParadigm)
        }

        if let engine_id = self.engine_id {
            let engineJSONAdapter = VehicleprofileModule.EngineJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: engine_id)
            let engineRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: jsonmap.predicate, linkedClazz: VehicleprofileEngine.self, linkedObjectID: engine_id)
            let engineRequstParadigm = MappingParadigm(clazz: VehicleprofileEngine.self, adapter: engineJSONAdapter, requestPredicateComposer: engineRequestComposer, keypathPrefix: "engine.")
            inContext.requestManager?.fetchRemote(paradigm: engineRequstParadigm)
        }

        if let suspension_id = self.suspension_id {
            let suspensionJSONAdapter = VehicleprofileModule.SuspensionJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: suspension_id)
            let suspensionRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: jsonmap.predicate, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: suspension_id)
            let suspensionRequestParadigm = MappingParadigm(clazz: VehicleprofileSuspension.self, adapter: suspensionJSONAdapter, requestPredicateComposer: suspensionRequestComposer, keypathPrefix: "suspension.")
            inContext.requestManager?.fetchRemote(paradigm: suspensionRequestParadigm)
        }

        if let turret_id = self.turret_id {
            let turretJSONAdapter = VehicleprofileModule.TurretJSONAdapterHelper(masterFetchResult: masterFetchResult, mappedObjectIdentifier: turret_id)
            let turretRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: jsonmap.predicate, linkedClazz: VehicleprofileTurret.self, linkedObjectID: turret_id)
            let turretRequestParadigm = MappingParadigm(clazz: VehicleprofileTurret.self, adapter: turretJSONAdapter, requestPredicateComposer: turretRequestComposer, keypathPrefix: "turret.")
            inContext.requestManager?.fetchRemote(paradigm: turretRequestParadigm)
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileSuspension.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
                return
            }
            vehicleProfileSuspension.suspension_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleChassis = vehicleProfileSuspension
            dataStore?.stash(objectContext: managedObjectContext) { error in
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
                return
            }
            vehicleProfileEngine.engine_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleEngine = vehicleProfileEngine
            dataStore?.stash(objectContext: managedObjectContext) { error in
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileTurret.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileTurret.self))
                return
            }
            vehicleProfileTurret.turret_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleTurret = vehicleProfileTurret
            dataStore?.stash(objectContext: managedObjectContext) { error in
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileRadio.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileRadio.self))
                return
            }
            vehicleProfileRadio.radio_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleRadio = vehicleProfileRadio
            dataStore?.stash(objectContext: managedObjectContext) { error in
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

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileGun.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
                return
            }
            vehicleProfileGun.gun_id = mappedObjectIdentifier as? NSDecimalNumber
            module.vehicleGun = vehicleProfileGun
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }
}
