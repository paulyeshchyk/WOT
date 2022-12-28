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
    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let profileModule = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try self.decode(decoderContainer: profileModule)
        //

        let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        if let gun_id = self.gun_id {
            let gunJSONAdapter = VehicleprofileModule.GunLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: gun_id)
            let gunPredicateComposer = VehicleprofileModule.GunPredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileGun.self, linkedObjectID: gun_id)
            let gunRequestParadigm = RequestParadigm(modelClass: VehicleprofileGun.self, requestPredicateComposer: gunPredicateComposer, keypathPrefix: "gun.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: gunRequestParadigm, requestPredicateComposer: gunPredicateComposer, managedObjectCreator: gunJSONAdapter, listener: self)
        }

        if let radio_id = self.radio_id {
            let radioJSONAdapter = VehicleprofileModule.RadioLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: radio_id)
            let radioPredicateComposer = VehicleprofileModule.RadioPredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileRadio.self, linkedObjectID: radio_id)
            let radioRequestParadigm = RequestParadigm(modelClass: VehicleprofileRadio.self, requestPredicateComposer: radioPredicateComposer, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: radioRequestParadigm, requestPredicateComposer: radioPredicateComposer, managedObjectCreator: radioJSONAdapter, listener: self)
        }

        if let engine_id = self.engine_id {
            let engineJSONAdapter = VehicleprofileModule.EngineLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: engine_id)
            let enginePredicateComposer = VehicleprofileModule.EnginePredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileEngine.self, linkedObjectID: engine_id)
            let engineRequstParadigm = RequestParadigm(modelClass: VehicleprofileEngine.self, requestPredicateComposer: enginePredicateComposer, keypathPrefix: "engine.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: engineRequstParadigm, requestPredicateComposer: enginePredicateComposer, managedObjectCreator: engineJSONAdapter, listener: self)
        }

        if let suspension_id = self.suspension_id {
            let suspensionJSONAdapter = VehicleprofileModule.SuspensionLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: suspension_id)
            let suspensionPredicateComposer = VehicleprofileModule.SuspensionPredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: suspension_id)
            let suspensionRequestParadigm = RequestParadigm(modelClass: VehicleprofileSuspension.self, requestPredicateComposer: suspensionPredicateComposer, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: suspensionRequestParadigm, requestPredicateComposer: suspensionPredicateComposer, managedObjectCreator: suspensionJSONAdapter, listener: self)
        }

        if let turret_id = self.turret_id {
            let turretJSONAdapter = VehicleprofileModule.TurretLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: turret_id)
            let turretPredicateComposer = VehicleprofileModule.TurretPredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileTurret.self, linkedObjectID: turret_id)
            let turretRequestParadigm = RequestParadigm(modelClass: VehicleprofileTurret.self, requestPredicateComposer: turretPredicateComposer, keypathPrefix: "turret.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: turretRequestParadigm, requestPredicateComposer: turretPredicateComposer, managedObjectCreator: turretJSONAdapter, listener: self)
        }
    }
}

extension VehicleprofileModule: RequestManagerListenerProtocol {
    public var MD5: String { uuid.MD5 }
    public var uuid: UUID { UUID() }

    public func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType) {
        //
    }

    public func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol) {
        //
    }
}

// MARK: - Suspension

extension VehicleprofileModule {
    private class SuspensionPredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}

    private class SuspensionLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.suspension)] as? JSON }

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
}

extension VehicleprofileModule {
    private class EnginePredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}

    private class EngineLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.engine)] as? JSON }

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
}

extension VehicleprofileModule {
    private class TurretPredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}

    private class TurretLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.turret)] as? JSON }

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
}

extension VehicleprofileModule {
    private class RadioPredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}

    private class RadioLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.radio)] as? JSON }

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
}

extension VehicleprofileModule {
    private class GunPredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}

    private class GunLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.gun)] as? JSON }

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
