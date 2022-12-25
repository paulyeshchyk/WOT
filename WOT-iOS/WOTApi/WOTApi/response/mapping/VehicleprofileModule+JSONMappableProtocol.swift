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
            let gunRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: map.predicate, linkedClazz: VehicleprofileGun.self, linkedObjectID: gun_id)
            let gunRequestParadigm = MappingParadigm(clazz: VehicleprofileGun.self, adapter: gunJSONAdapter, requestPredicateComposer: gunRequestComposer, keypathPrefix: "gun.")
            try inContext.requestManager?.fetchRemote(paradigm: gunRequestParadigm, listener: self)
        }

        if let radio_id = self.radio_id {
            let radioJSONAdapter = VehicleprofileModule.RadioLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: radio_id)
            let radioRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: map.predicate, linkedClazz: VehicleprofileRadio.self, linkedObjectID: radio_id)
            let radioRequestParadigm = MappingParadigm(clazz: VehicleprofileRadio.self, adapter: radioJSONAdapter, requestPredicateComposer: radioRequestComposer, keypathPrefix: "radio.")
            try inContext.requestManager?.fetchRemote(paradigm: radioRequestParadigm, listener: self)
        }

        if let engine_id = self.engine_id {
            let engineJSONAdapter = VehicleprofileModule.EngineLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: engine_id)
            let engineRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: map.predicate, linkedClazz: VehicleprofileEngine.self, linkedObjectID: engine_id)
            let engineRequstParadigm = MappingParadigm(clazz: VehicleprofileEngine.self, adapter: engineJSONAdapter, requestPredicateComposer: engineRequestComposer, keypathPrefix: "engine.")
            try inContext.requestManager?.fetchRemote(paradigm: engineRequstParadigm, listener: self)
        }

        if let suspension_id = self.suspension_id {
            let suspensionJSONAdapter = VehicleprofileModule.SuspensionLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: suspension_id)
            let suspensionRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: map.predicate, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: suspension_id)
            let suspensionRequestParadigm = MappingParadigm(clazz: VehicleprofileSuspension.self, adapter: suspensionJSONAdapter, requestPredicateComposer: suspensionRequestComposer, keypathPrefix: "suspension.")
            try inContext.requestManager?.fetchRemote(paradigm: suspensionRequestParadigm, listener: self)
        }

        if let turret_id = self.turret_id {
            let turretJSONAdapter = VehicleprofileModule.TurretLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: turret_id)
            let turretRequestComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(requestPredicate: map.predicate, linkedClazz: VehicleprofileTurret.self, linkedObjectID: turret_id)
            let turretRequestParadigm = MappingParadigm(clazz: VehicleprofileTurret.self, adapter: turretJSONAdapter, requestPredicateComposer: turretRequestComposer, keypathPrefix: "turret.")
            try inContext.requestManager?.fetchRemote(paradigm: turretRequestParadigm, listener: self)
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

extension VehicleprofileModule {
    
    private class SuspensionLinker: BaseJSONAdapterLinker {
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

    private class EngineLinker: BaseJSONAdapterLinker {
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

    private class TurretLinker: BaseJSONAdapterLinker {
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

    private class RadioLinker: BaseJSONAdapterLinker {
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

    private class GunLinker: BaseJSONAdapterLinker {
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
