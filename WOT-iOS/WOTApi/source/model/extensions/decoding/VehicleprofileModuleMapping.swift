//
//  VehicleprofileModule+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileModule {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        guard let profileModuleJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: profileModuleJSON)
        //

        let vehicleprofileModuleFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        if let gun_id = gun_id {
            let modelClass = VehicleprofileGun.self
            let socket = ManagedObjectLinkerSocket(identifier: gun_id, keypath: #keyPath(VehicleprofileModule.gun_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, socket: socket)
            let pin = ManagedObjectLinkerPin(modelClass: modelClass, identifier: gun_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            let extractor = GunExtractor()
            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }

        if let radio_id = radio_id {
            let modelClass = VehicleprofileRadio.self
            let socket = ManagedObjectLinkerSocket(identifier: radio_id, keypath: #keyPath(VehicleprofileModule.radio_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, socket: socket)
            let extractor = RadioExtractor()
            let pin = ManagedObjectLinkerPin(modelClass: modelClass, identifier: radio_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }

        if let engine_id = engine_id {
            let modelClass = VehicleprofileEngine.self
            let socket = ManagedObjectLinkerSocket(identifier: engine_id, keypath: #keyPath(VehicleprofileModule.engine_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, socket: socket)
            let extractor = EngineExtractor()
            let pin = ManagedObjectLinkerPin(modelClass: modelClass, identifier: engine_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }

        if let suspension_id = suspension_id {
            let modelClass = VehicleprofileSuspension.self
            let socket = ManagedObjectLinkerSocket(identifier: suspension_id, keypath: #keyPath(VehicleprofileModule.suspension_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, socket: socket)
            let extractor = SuspensionExtractor()
            let pin = ManagedObjectLinkerPin(modelClass: modelClass, identifier: suspension_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }

        if let turret_id = turret_id {
            let modelClass = VehicleprofileTurret.self
            let socket = ManagedObjectLinkerSocket(identifier: turret_id, keypath: #keyPath(VehicleprofileModule.turret_id))
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileModuleFetchResult, socket: socket)
            let extractor = TurretExtractor()
            let pin = ManagedObjectLinkerPin(modelClass: modelClass, identifier: turret_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
        }
    }
}

extension VehicleprofileModule {

    private class GunExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.gun) }
    }

    private class RadioExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.radio) }
    }

    private class EngineExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.engine) }
    }

    private class SuspensionExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.suspension) }
    }

    private class TurretExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.turret) }
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
