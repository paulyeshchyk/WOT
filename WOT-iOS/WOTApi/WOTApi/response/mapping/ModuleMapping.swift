//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension Module {
    // MARK: - JSONMappableProtocol

    override public func mapping(with map: JSONManagedObjectMapProtocol, appContext: JSONMappableProtocol.Context) throws {
        guard let moduleJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try self.decode(decoderContainer: moduleJSON)
        //

        let parentsAsVehicles = map.predicate.parentObjectIDList
            .compactMap { map.managedObjectContext.object(byID: $0) as? Vehicles }
        let parents = parentsAsVehicles.compactMap { $0.tank_id }

        let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        guard parents.count <= 1 else {
            print("parents count should be less or equal 1")
            return
        }
        let tank_id = parents.first

        guard let module_id = self.module_id else {
            print("module_id not found")
            return
        }

        let moduleType = VehicleModuleType.fromString(self.type)
        switch moduleType {
        case .vehicleChassis:
            let chassisCreator = ModuleVehicleprofileSuspensionManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let chassisPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: module_id)
            let chassisRequestParadigm = RequestParadigm(modelClass: VehicleprofileSuspension.self, requestPredicateComposer: chassisPredicateComposer, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: chassisRequestParadigm, requestPredicateComposer: chassisPredicateComposer, managedObjectCreator: chassisCreator, listener: self)
        case .vehicleGun:
            let gunCreator = ModuleVehicleprofileGunManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let gunPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileGun.self, linkedObjectID: module_id)
            let gunRequestParadigm = RequestParadigm(modelClass: VehicleprofileGun.self, requestPredicateComposer: gunPredicateComposer, keypathPrefix: "gun.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: gunRequestParadigm, requestPredicateComposer: gunPredicateComposer, managedObjectCreator: gunCreator, listener: self)
        case .vehicleRadio:
            let radioCreator = ModuleVehicleprofileRadioManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let radioPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileRadio.self, linkedObjectID: module_id)
            let radioRequestParadigm = RequestParadigm(modelClass: VehicleprofileRadio.self, requestPredicateComposer: radioPredicateComposer, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: radioRequestParadigm, requestPredicateComposer: radioPredicateComposer, managedObjectCreator: radioCreator, listener: self)
        case .vehicleEngine:
            let engineCreator = ModuleVehicleprofileEngineManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let enginePredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileEngine.self, linkedObjectID: module_id)
            let engineRequestParadigm = RequestParadigm(modelClass: VehicleprofileEngine.self, requestPredicateComposer: enginePredicateComposer, keypathPrefix: "engine.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: engineRequestParadigm, requestPredicateComposer: enginePredicateComposer, managedObjectCreator: engineCreator, listener: self)
        case .vehicleTurret:
            let turretCreator = ModuleVehicleprofileTurretManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let turretPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileTurret.self, linkedObjectID: module_id)
            let turretRequestParadigm = RequestParadigm(modelClass: VehicleprofileTurret.self, requestPredicateComposer: turretPredicateComposer, keypathPrefix: "turret.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: turretRequestParadigm, requestPredicateComposer: turretPredicateComposer, managedObjectCreator: turretCreator, listener: self)
        default: fatalError("unknown module type")
        }
    }
}

extension Module: RequestManagerListenerProtocol {
    public var MD5: String { uuid.MD5 }
    public var uuid: UUID { UUID() }

    public func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType) {
        //
    }

    public func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol) {
        //
    }
}
