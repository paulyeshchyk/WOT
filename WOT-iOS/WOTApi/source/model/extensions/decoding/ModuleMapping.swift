//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Module {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        guard let moduleJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: moduleJSON)
        //

        let parentsAsVehicles = map.contextPredicate.parentObjectIDList
            .compactMap { managedObjectContextContainer.managedObjectContext.object(byID: $0) as? Vehicles }
        let parents = parentsAsVehicles.compactMap { $0.tank_id }

        let moduleFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        guard !parents.isEmpty else {
            throw ModuleMappingError.noParentsFound
        }
        let tank_id = parents.first

        guard let module_id = module_id else {
            throw ModuleMappingError.moduleIdNotDefined
        }

        let hostJoint = Joint(modelClass: Vehicles.self, theID: tank_id, contextPredicate: nil)

        let moduleType = VehicleModuleType.fromString(type)
        switch moduleType {
        case .vehicleGun:
            let modelClass = VehicleprofileGun.self
            let keypath = #keyPath(Module.gun)
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: keypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, anchor: anchor)
            let extractor = ModuleVehicleprofileGunManagedObjectCreator()
            let joint = Joint(modelClass: modelClass, theID: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let composition = try composer.buildRequestPredicateComposition()
            let gunRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "gun.", httpQueryItemName: "fields")
            try appContext?.requestManager?.fetchRemote(requestParadigm: gunRequestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        case .vehicleRadio:
            let modelClass = VehicleprofileRadio.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.radio))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, anchor: anchor)
            let extractor = ModuleVehicleprofileRadioManagedObjectCreator()
            let joint = Joint(modelClass: modelClass, theID: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let composition = try composer.buildRequestPredicateComposition()
            let radioRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try appContext?.requestManager?.fetchRemote(requestParadigm: radioRequestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        case .vehicleEngine:
            let modelClass = VehicleprofileEngine.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.engine))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, anchor: anchor)
            let joint = Joint(modelClass: modelClass, theID: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let composition = try composer.buildRequestPredicateComposition()
            let engineRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "engine.", httpQueryItemName: "fields")
            let extractor = ModuleVehicleprofileEngineManagedObjectExtractor()
            try appContext?.requestManager?.fetchRemote(requestParadigm: engineRequestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        case .vehicleChassis:
            let modelClass = VehicleprofileSuspension.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.suspension))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, anchor: anchor)
            let extractor = ModuleVehicleprofileSuspensionManagedObjectCreator()
            let joint = Joint(modelClass: modelClass, theID: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let composition = try composer.buildRequestPredicateComposition()
            let chassisRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try appContext?.requestManager?.fetchRemote(requestParadigm: chassisRequestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        case .vehicleTurret:
            let modelClass = VehicleprofileTurret.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.turret))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, anchor: anchor)
            let extractor = ModuleVehicleprofileTurretManagedObjectCreator()
            let joint = Joint(modelClass: modelClass, theID: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let composition = try composer.buildRequestPredicateComposition()
            let turretRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: "turret.", httpQueryItemName: "fields")
            try appContext?.requestManager?.fetchRemote(requestParadigm: turretRequestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        default:
            throw ModuleMappingError.unexpectedModuleType(moduleType)
        }
    }
}

// MARK: - Module + RequestManagerListenerProtocol

extension Module: RequestManagerListenerProtocol {
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

// MARK: - ModuleMappingError

private enum ModuleMappingError: Error {
    case noParentsFound
    case moduleIdNotDefined
    case unexpectedModuleType(VehicleModuleType)
}
