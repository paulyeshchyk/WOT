//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Module {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        //
        let moduleJSON = try map.data(ofType: JSON.self)
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

        let hostPin = JointPin(modelClass: Vehicles.self, identifier: tank_id, contextPredicate: nil)

        let moduleType = VehicleModuleType.fromString(type)
        switch moduleType {
        case .vehicleGun:
            let modelClass = VehicleprofileGun.self
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.gun))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
            let extractor = GunExtractor()
            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, hostPin: hostPin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        case .vehicleRadio:
            let modelClass = VehicleprofileRadio.self
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.radio))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
            let extractor = RadioExtractor()
            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, hostPin: hostPin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        case .vehicleEngine:
            let modelClass = VehicleprofileEngine.self
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.engine))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, hostPin: hostPin)
            let composition = try composer.buildRequestPredicateComposition()
            let extractor = EngineExtractor()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        case .vehicleChassis:
            let modelClass = VehicleprofileSuspension.self
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.suspension))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
            let extractor = SuspensionExtractor()
            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, hostPin: hostPin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        case .vehicleTurret:
            let modelClass = VehicleprofileTurret.self
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.turret))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
            let extractor = TurretExtractor()
            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)
            let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, hostPin: hostPin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
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

extension Module {

    private class EngineExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.engine) }
    }

    private class GunExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.gun) }
    }

    private class RadioExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.radio) }
    }

    private class SuspensionExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.suspension) }
    }

    private class TurretExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.turret) }
    }

}
