//
//  VehicleprofileModule+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileModule {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let profileModuleJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: profileModuleJSON)
        //

        let vehicleprofileModuleFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        if let gun_id = gun_id {
            let modelClass = VehicleprofileGun.self
            let anchor = ManagedObjectLinkerAnchor(identifier: gun_id, keypath: #keyPath(VehicleprofileModule.gun_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, anchor: anchor)
            let joint = Joint(modelClass: modelClass, theID: gun_id, thePredicate: map.predicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let composition = try composer.buildRequestPredicateComposition()
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "gun.", httpQueryItemName: "fields")
            let extractor = VehicleprofileModuleGunManagedObjectExtractor()
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }

        if let radio_id = radio_id {
            let modelClass = VehicleprofileRadio.self
            let anchor = ManagedObjectLinkerAnchor(identifier: radio_id, keypath: #keyPath(VehicleprofileModule.radio_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, anchor: anchor)
            let extractor = VehicleprofileModuleRadioManagedObjectCreator()
            let joint = Joint(modelClass: modelClass, theID: radio_id, thePredicate: map.predicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let composition = try composer.buildRequestPredicateComposition()
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }

        if let engine_id = engine_id {
            let modelClass = VehicleprofileEngine.self
            let anchor = ManagedObjectLinkerAnchor(identifier: engine_id, keypath: #keyPath(VehicleprofileModule.engine_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, anchor: anchor)
            let extractor = VehicleprofileModuleEngineManagedObjectCreator()
            let joint = Joint(modelClass: modelClass, theID: engine_id, thePredicate: map.predicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let composition = try composer.buildRequestPredicateComposition()
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "engine.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }

        if let suspension_id = suspension_id {
            let modelClass = VehicleprofileSuspension.self
            let anchor = ManagedObjectLinkerAnchor(identifier: suspension_id, keypath: #keyPath(VehicleprofileModule.suspension_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, anchor: anchor)
            let extractor = VehicleprofileModuleSuspensionManagedObjectCreator()
            let joint = Joint(modelClass: modelClass, theID: suspension_id, thePredicate: map.predicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let composition = try composer.buildRequestPredicateComposition()
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }

        if let turret_id = turret_id {
            let modelClass = VehicleprofileTurret.self
            let anchor = ManagedObjectLinkerAnchor(identifier: turret_id, keypath: #keyPath(VehicleprofileModule.turret_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, anchor: anchor)
            let extractor = VehicleprofileModuleTurretManagedObjectCreator()
            let joint = Joint(modelClass: modelClass, theID: turret_id, thePredicate: map.predicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let composition = try composer.buildRequestPredicateComposition()
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "turret.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }
    }
}

// MARK: - VehicleprofileModule + RequestManagerListenerProtocol

extension VehicleprofileModule: RequestManagerListenerProtocol {
    public func requestManager(_: RequestManagerProtocol, didParseDataForRequest _: RequestProtocol, error _: Error?) {
        //
    }

    public func requestManager(_: RequestManagerProtocol, didStartRequest _: RequestProtocol) {
        //
    }

    public func requestManager(_: RequestManagerProtocol, didCancelRequest _: RequestProtocol, reason _: RequestCancelReasonProtocol) {
        //
    }
}
