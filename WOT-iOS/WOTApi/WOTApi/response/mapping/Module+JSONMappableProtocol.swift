//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension Module {
    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let module = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }

        //
        try self.decode(decoderContainer: module)
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
            let chassisCreator = Module.VehicleprofileSuspensionCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let chassisPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileSuspension.self, linkedObjectID: module_id)
            let chassisRequestParadigm = RequestParadigm(modelClass: VehicleprofileSuspension.self, requestPredicateComposer: chassisPredicateComposer, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: chassisRequestParadigm, requestPredicateComposer: chassisPredicateComposer, managedObjectCreator: chassisCreator, listener: self)
        case .vehicleGun:
            let gunCreator = Module.VehicleprofileGunCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let gunPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileGun.self, linkedObjectID: module_id)
            let gunRequestParadigm = RequestParadigm(modelClass: VehicleprofileGun.self, requestPredicateComposer: gunPredicateComposer, keypathPrefix: "gun.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: gunRequestParadigm, requestPredicateComposer: gunPredicateComposer, managedObjectCreator: gunCreator, listener: self)
        case .vehicleRadio:
            let radioCreator = Module.VehicleprofileRadioRadio(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let radioPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileRadio.self, linkedObjectID: module_id)
            let radioRequestParadigm = RequestParadigm(modelClass: VehicleprofileRadio.self, requestPredicateComposer: radioPredicateComposer, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: radioRequestParadigm, requestPredicateComposer: radioPredicateComposer, managedObjectCreator: radioCreator, listener: self)
        case .vehicleEngine:
            let engineCreator = Module.VehicleprofileEngineCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let enginePredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileEngine.self, linkedObjectID: module_id)
            let engineRequestParadigm = RequestParadigm(modelClass: VehicleprofileEngine.self, requestPredicateComposer: enginePredicateComposer, keypathPrefix: "engine.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: engineRequestParadigm, requestPredicateComposer: enginePredicateComposer, managedObjectCreator: engineCreator, listener: self)
        case .vehicleTurret:
            let turretCreator = Module.VehicleprofileTurretCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
            let turretPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(masterClazz: Vehicles.self, masterObjectID: tank_id, linkedClazz: VehicleprofileTurret.self, linkedObjectID: module_id)
            let turretRequestParadigm = RequestParadigm(modelClass: VehicleprofileTurret.self, requestPredicateComposer: turretPredicateComposer, keypathPrefix: "turret.", httpQueryItemName: "fields")
            try inContext.requestManager?.fetchRemote(requestParadigm: turretRequestParadigm, requestPredicateComposer: turretPredicateComposer, managedObjectCreator: turretCreator, listener: self)
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

extension Module {
    private class VehicleprofileEngineCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.engine)] as? JSON }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
                return
            }
            guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Module.self))
                return
            }
            vehicleProfileEngine.engine_id = self.mappedObjectIdentifier as? NSDecimalNumber
            module.engine = vehicleProfileEngine
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }
}

extension Module {
    private class VehicleprofileTurretCreator: ManagedObjectCreator {
        public required init(masterFetchResult: FetchResultProtocol?, mappedObjectIdentifier: Any?) {
            super.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: mappedObjectIdentifier)
        }

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.turret)] as? JSON }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                    vehicleProfileTurret.turret_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.turret = vehicleProfileTurret
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}

extension Module {
    private class VehicleprofileSuspensionCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.suspension)] as? JSON }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                    vehicleProfileSuspension.suspension_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.suspension = vehicleProfileSuspension
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}

extension Module {
    private class VehicleprofileRadioRadio: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.radio)] as? JSON }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                    vehicleProfileRadio.radio_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.radio = vehicleProfileRadio
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}

extension Module {
    private class VehicleprofileGunCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json[#keyPath(Vehicleprofile.gun)] as? JSON }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
                if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                    vehicleProfileGun.gun_id = self.mappedObjectIdentifier as? NSDecimalNumber
                    module.gun = vehicleProfileGun
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
