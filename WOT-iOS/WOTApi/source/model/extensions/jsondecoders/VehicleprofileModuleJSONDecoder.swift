//
//  VehicleprofileModuleJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileModuleJSONDecoder

class VehicleprofileModuleJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: JSONDecoderProtocol.Context?

    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel _: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)
        //

        if let gun_id = element?[#keyPath(VehicleprofileModule.gun_id)] {
            let modelClass = VehicleprofileGun.self
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: gun_id, keypath: #keyPath(VehicleprofileModule.gun_id))
            let linker = ManagedObjectLinker(modelClass: modelClass)
            linker.socket = socket
            let pin = JointPin(modelClass: modelClass, identifier: gun_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            let extractor = VehicleprofileModule.GunExtractor()
            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: nil)
        }

        if let radio_id = element?[#keyPath(VehicleprofileModule.radio_id)] {
            let modelClass = VehicleprofileRadio.self
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: radio_id, keypath: #keyPath(VehicleprofileModule.radio_id))
            let linker = ManagedObjectLinker(modelClass: modelClass)
            linker.socket = socket
            let extractor = VehicleprofileModule.RadioExtractor()
            let pin = JointPin(modelClass: modelClass, identifier: radio_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: nil)
        }

        if let engine_id = element?[#keyPath(VehicleprofileModule.engine_id)] {
            let modelClass = VehicleprofileEngine.self
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: engine_id, keypath: #keyPath(VehicleprofileModule.engine_id))
            let linker = ManagedObjectLinker(modelClass: modelClass)
            linker.socket = socket

            let extractor = VehicleprofileModule.EngineExtractor()
            let pin = JointPin(modelClass: modelClass, identifier: engine_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: nil)
        }

        if let suspension_id = element?[#keyPath(VehicleprofileModule.suspension_id)] {
            let modelClass = VehicleprofileSuspension.self
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: suspension_id, keypath: #keyPath(VehicleprofileModule.suspension_id))
            let linker = ManagedObjectLinker(modelClass: modelClass)
            linker.socket = socket

            let extractor = VehicleprofileModule.SuspensionExtractor()
            let pin = JointPin(modelClass: modelClass, identifier: suspension_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: nil)
        }

        if let turret_id = element?[#keyPath(VehicleprofileModule.turret_id)] {
            let modelClass = VehicleprofileTurret.self
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: turret_id, keypath: #keyPath(VehicleprofileModule.turret_id))
            let linker = ManagedObjectLinker(modelClass: modelClass)
            linker.socket = socket

            let extractor = VehicleprofileModule.TurretExtractor()
            let pin = JointPin(modelClass: modelClass, identifier: turret_id, contextPredicate: map.contextPredicate)
            let composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: nil)
        }
    }
}

extension VehicleprofileModule {

    class GunExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.gun) }
    }

    class RadioExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.radio) }
    }

    class EngineExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.engine) }
    }

    class SuspensionExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.suspension) }
    }

    class TurretExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.turret) }
    }
}
