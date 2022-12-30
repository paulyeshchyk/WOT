//
//  VehicleprofileModule+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileModule {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let profileModuleJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: profileModuleJSON)
        //

        let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        if let gun_id = gun_id {
            let gunJSONAdapter = VehicleprofileModuleGunManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: gun_id)
            let gunPredicateComposer = VehicleprofileModuleGunPredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileGun.self, linkedObjectID: gun_id)
            let gunRequestParadigm = RequestParadigm(modelClass: VehicleprofileGun.self, requestPredicateComposer: gunPredicateComposer, keypathPrefix: "gun.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: gunRequestParadigm, managedObjectCreator: gunJSONAdapter, listener: self)
        }

        if let radio_id = radio_id {
            let radioJSONAdapter = VehicleprofileModuleRadioManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: radio_id)
            let radioPredicateComposer = VehicleprofileModuleRadioPredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileRadio.self, linkedObjectID: radio_id)
            let radioRequestParadigm = RequestParadigm(modelClass: VehicleprofileRadio.self, requestPredicateComposer: radioPredicateComposer, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: radioRequestParadigm, managedObjectCreator: radioJSONAdapter, listener: self)
        }

        if let engine_id = engine_id {
            let engineJSONAdapter = VehicleprofileModuleEngineManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: engine_id)
            let enginePredicateComposer = VehicleprofileModuleEnginePredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileEngine.self, linkedObjectID: engine_id)
            let engineRequstParadigm = RequestParadigm(modelClass: VehicleprofileEngine.self, requestPredicateComposer: enginePredicateComposer, keypathPrefix: "engine.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: engineRequstParadigm, managedObjectCreator: engineJSONAdapter, listener: self)
        }

        if let suspension_id = suspension_id {
            let suspensionJSONAdapter = VehicleprofileModuleSuspensionManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: suspension_id)
            let suspensionPredicateComposer = VehicleprofileModuleSuspensionPredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: suspension_id)
            let suspensionRequestParadigm = RequestParadigm(modelClass: VehicleprofileSuspension.self, requestPredicateComposer: suspensionPredicateComposer, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: suspensionRequestParadigm, managedObjectCreator: suspensionJSONAdapter, listener: self)
        }

        if let turret_id = turret_id {
            let turretJSONAdapter = VehicleprofileModuleTurretManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: turret_id)
            let turretPredicateComposer = VehicleprofileModuleTurretPredicateComposer(requestPredicate: map.predicate, linkedClazz: VehicleprofileTurret.self, linkedObjectID: turret_id)
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
