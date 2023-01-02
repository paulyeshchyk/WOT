//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Module {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let moduleJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: moduleJSON)
        //

        let parentsAsVehicles = map.predicate.parentObjectIDList
            .compactMap { managedObjectContextContainer.managedObjectContext.object(byID: $0) as? Vehicles }
        let parents = parentsAsVehicles.compactMap { $0.tank_id }

        let masterFetchResult = FetchResult(objectID: objectID, inContext: managedObjectContextContainer.managedObjectContext, predicate: nil, fetchStatus: .recovered)

        guard !parents.isEmpty else {
            throw ModuleMappingError.noParentsFound
        }
        let tank_id = parents.first

        guard let module_id = module_id else {
            throw ModuleMappingError.moduleIdNotDefined
        }

        let hostJoint = Joint(theClass: Vehicles.self, theID: tank_id, thePredicate: nil)

        let moduleType = VehicleModuleType.fromString(type)
        switch moduleType {
        case .vehicleGun:
            let modelClass = VehicleprofileGun.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.gun))
            let linker = ModuleVehicleprofileGunManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: module_id, thePredicate: nil)
            let gunPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let gunRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: gunPredicateComposer, keypathPrefix: "gun.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: gunRequestParadigm, linker: linker, listener: self)
        case .vehicleRadio:
            let modelClass = VehicleprofileRadio.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.radio))
            let linker = ModuleVehicleprofileRadioManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: module_id, thePredicate: nil)
            let radioPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let radioRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: radioPredicateComposer, keypathPrefix: "radio.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: radioRequestParadigm, linker: linker, listener: self)
        case .vehicleEngine:
            let modelClass = VehicleprofileEngine.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.engine))
            let linker = ModuleVehicleprofileEngineManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: module_id, thePredicate: nil)
            let enginePredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let engineRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: enginePredicateComposer, keypathPrefix: "engine.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: engineRequestParadigm, linker: linker, listener: self)
        case .vehicleChassis:
            let modelClass = VehicleprofileSuspension.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.suspension))
            let linker = ModuleVehicleprofileSuspensionManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: module_id, thePredicate: nil)
            let chassisPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let chassisRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: chassisPredicateComposer, keypathPrefix: "suspension.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: chassisRequestParadigm, linker: linker, listener: self)
        case .vehicleTurret:
            let modelClass = VehicleprofileTurret.self
            let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(Module.turret))
            let linker = ModuleVehicleprofileTurretManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            let joint = Joint(theClass: modelClass, theID: module_id, thePredicate: nil)
            let turretPredicateComposer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(drivenJoint: joint, hostJoint: hostJoint)
            let turretRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: turretPredicateComposer, keypathPrefix: "turret.", httpQueryItemName: "fields")
            try appContext.requestManager?.fetchRemote(requestParadigm: turretRequestParadigm, linker: linker, listener: self)
        default:
            throw ModuleMappingError.unexpectedModuleType(moduleType)
        }
    }
}

extension Module: RequestManagerListenerProtocol {
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

private enum ModuleMappingError: Error {
    case noParentsFound
    case moduleIdNotDefined
    case unexpectedModuleType(VehicleModuleType)
}
