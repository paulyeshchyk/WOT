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

        let masterFetchResult = FetchResult(objectID: objectID, inContext: managedObjectContextContainer.managedObjectContext, predicate: nil, fetchStatus: .recovered)

        if let gun_id = gun_id {
            let modelClass = VehicleprofileGun.self
            let anchor = ManagedObjectLinkerAnchor(identifier: gun_id, keypath: #keyPath(VehicleprofileModule.gun_id))
            let linker = VehicleprofileModuleGunManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: gun_id, thePredicate: map.predicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: composer, keypathPrefix: "gun.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, linker: linker, listener: self)
        }

        if let radio_id = radio_id {
            let modelClass = VehicleprofileRadio.self
            let anchor = ManagedObjectLinkerAnchor(identifier: radio_id, keypath: #keyPath(VehicleprofileModule.radio_id))
            let linker = VehicleprofileModuleRadioManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: radio_id, thePredicate: map.predicate)
            let radioPredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: radioPredicateComposer, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, linker: linker, listener: self)
        }

        if let engine_id = engine_id {
            let modelClass = VehicleprofileEngine.self
            let anchor = ManagedObjectLinkerAnchor(identifier: engine_id, keypath: #keyPath(VehicleprofileModule.engine_id))
            let linker = VehicleprofileModuleEngineManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: engine_id, thePredicate: map.predicate)
            let enginePredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: enginePredicateComposer, keypathPrefix: "engine.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, linker: linker, listener: self)
        }

        if let suspension_id = suspension_id {
            let modelClass = VehicleprofileSuspension.self
            let anchor = ManagedObjectLinkerAnchor(identifier: suspension_id, keypath: #keyPath(VehicleprofileModule.suspension_id))
            let linker = VehicleprofileModuleSuspensionManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: suspension_id, thePredicate: map.predicate)
            let suspensionPredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: suspensionPredicateComposer, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, linker: linker, listener: self)
        }

        if let turret_id = turret_id {
            let modelClass = VehicleprofileTurret.self
            let anchor = ManagedObjectLinkerAnchor(identifier: turret_id, keypath: #keyPath(VehicleprofileModule.turret_id))
            let linker = VehicleprofileModuleTurretManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: turret_id, thePredicate: map.predicate)
            let turretPredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: joint)
            let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: turretPredicateComposer, keypathPrefix: "turret.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, linker: linker, listener: self)
        }
    }
}

extension VehicleprofileModule: RequestManagerListenerProtocol {
    public var MD5: String { uuid.MD5 }
    public var uuid: UUID { UUID() }

    public func requestManager(_: RequestManagerProtocol, didParseDataForRequest _: RequestProtocol, completionResultType _: WOTRequestManagerCompletionResultType) {
        //
    }

    public func requestManager(_: RequestManagerProtocol, didStartRequest _: RequestProtocol) {
        //
    }

    public func requestManager(_: RequestManagerProtocol, didCancelRequest _: RequestProtocol, reason _: RequestCancelReasonProtocol) {
        //
    }
}
