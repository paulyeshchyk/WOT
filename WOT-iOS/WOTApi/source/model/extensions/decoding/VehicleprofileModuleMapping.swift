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

        let masterFetchResult = FetchResult(objectContext: managedObjectContextContainer.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        if let gun_id = gun_id {
            let gunJSONAdapter = VehicleprofileModuleGunManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: gun_id)
            let theLink = Joint(theClass: VehicleprofileGun.self, theID: gun_id, thePredicate: map.predicate)
            let gunPredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: theLink)
            let gunRequestParadigm = RequestParadigm(modelClass: VehicleprofileGun.self, requestPredicateComposer: gunPredicateComposer, keypathPrefix: "gun.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: gunRequestParadigm, managedObjectCreator: gunJSONAdapter, listener: self)
        }

        if let radio_id = radio_id {
            let radioJSONAdapter = VehicleprofileModuleRadioManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: radio_id)
            let theLink = Joint(theClass: VehicleprofileRadio.self, theID: radio_id, thePredicate: map.predicate)
            let radioPredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: theLink)
            let radioRequestParadigm = RequestParadigm(modelClass: VehicleprofileRadio.self, requestPredicateComposer: radioPredicateComposer, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: radioRequestParadigm, managedObjectCreator: radioJSONAdapter, listener: self)
        }

        if let engine_id = engine_id {
            let engineJSONAdapter = VehicleprofileModuleEngineManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: engine_id)
            let theLink = Joint(theClass: VehicleprofileEngine.self, theID: engine_id, thePredicate: map.predicate)
            let enginePredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: theLink)
            let engineRequstParadigm = RequestParadigm(modelClass: VehicleprofileEngine.self, requestPredicateComposer: enginePredicateComposer, keypathPrefix: "engine.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: engineRequstParadigm, managedObjectCreator: engineJSONAdapter, listener: self)
        }

        if let suspension_id = suspension_id {
            let suspensionJSONAdapter = VehicleprofileModuleSuspensionManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: suspension_id)
            let theLink = Joint(theClass: VehicleprofileSuspension.self, theID: suspension_id, thePredicate: map.predicate)
            let suspensionPredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: theLink)
            let suspensionRequestParadigm = RequestParadigm(modelClass: VehicleprofileSuspension.self, requestPredicateComposer: suspensionPredicateComposer, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: suspensionRequestParadigm, managedObjectCreator: suspensionJSONAdapter, listener: self)
        }

        if let turret_id = turret_id {
            let turretJSONAdapter = VehicleprofileModuleTurretManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: turret_id)
            let theLink = Joint(theClass: VehicleprofileTurret.self, theID: turret_id, thePredicate: map.predicate)
            let turretPredicateComposer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(drivenJoint: theLink)
            let turretRequestParadigm = RequestParadigm(modelClass: VehicleprofileTurret.self, requestPredicateComposer: turretPredicateComposer, keypathPrefix: "turret.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: turretRequestParadigm, managedObjectCreator: turretJSONAdapter, listener: self)
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
