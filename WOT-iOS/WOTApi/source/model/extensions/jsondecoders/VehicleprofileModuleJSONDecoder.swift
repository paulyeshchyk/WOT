//
//  VehicleprofileModuleJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileModuleJSONDecoder

class VehicleprofileModuleJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: VehicleprofileModuleJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        if let gun_id = element?[#keyPath(VehicleprofileModule.gun_id)] {
            //
            let modelClass = VehicleprofileGun.self
            let managedRef = try managedObject?.managedRef()

            let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
            httpJSONResponseConfiguration.socket = JointSocket(managedRef: managedRef!, identifier: gun_id, keypath: #keyPath(VehicleprofileModule.gun_id))
            httpJSONResponseConfiguration.extractor = VehicleprofileModule.GunExtractor()

            let pin = JointPin(modelClass: modelClass, identifier: gun_id, contextPredicate: map.contextPredicate)
            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
            httpRequestConfiguration.composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)

            #warning("move out of Decoder")
            let request = try appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration, decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
            try appContext.requestManager?.startRequest(request!, listener: nil)
        }

        if let radio_id = element?[#keyPath(VehicleprofileModule.radio_id)] {
            //
            let modelClass = VehicleprofileRadio.self
            let managedRef = try managedObject?.managedRef()

            let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
            httpJSONResponseConfiguration.socket = JointSocket(managedRef: managedRef!, identifier: radio_id, keypath: #keyPath(VehicleprofileModule.radio_id))
            httpJSONResponseConfiguration.extractor = VehicleprofileModule.RadioExtractor()

            let pin = JointPin(modelClass: modelClass, identifier: radio_id, contextPredicate: map.contextPredicate)
            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
            httpRequestConfiguration.composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)

            #warning("move out of Decoder")
            let request = try appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration, decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
            try appContext.requestManager?.startRequest(request!, listener: nil)
        }

        if let engine_id = element?[#keyPath(VehicleprofileModule.engine_id)] {
            //
            let modelClass = VehicleprofileEngine.self
            let managedRef = try managedObject?.managedRef()

            let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
            httpJSONResponseConfiguration.socket = JointSocket(managedRef: managedRef!, identifier: engine_id, keypath: #keyPath(VehicleprofileModule.engine_id))
            httpJSONResponseConfiguration.extractor = VehicleprofileModule.EngineExtractor()

            let pin = JointPin(modelClass: modelClass, identifier: engine_id, contextPredicate: map.contextPredicate)
            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
            httpRequestConfiguration.composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)

            #warning("move out of Decoder")
            let request = try appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration, decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
            try appContext.requestManager?.startRequest(request!, listener: nil)
        }

        if let suspension_id = element?[#keyPath(VehicleprofileModule.suspension_id)] {
            //
            let modelClass = VehicleprofileSuspension.self
            let managedRef = try managedObject?.managedRef()

            let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
            httpJSONResponseConfiguration.socket = JointSocket(managedRef: managedRef!, identifier: suspension_id, keypath: #keyPath(VehicleprofileModule.suspension_id))
            httpJSONResponseConfiguration.extractor = VehicleprofileModule.SuspensionExtractor()

            let pin = JointPin(modelClass: modelClass, identifier: suspension_id, contextPredicate: map.contextPredicate)
            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
            httpRequestConfiguration.composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)

            #warning("move out of Decoder")
            let request = try appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration, decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
            try appContext.requestManager?.startRequest(request!, listener: nil)
        }

        if let turret_id = element?[#keyPath(VehicleprofileModule.turret_id)] {
            //
            let modelClass = VehicleprofileTurret.self
            let managedRef = try managedObject?.managedRef()

            let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
            httpJSONResponseConfiguration.socket = JointSocket(managedRef: managedRef!, identifier: turret_id, keypath: #keyPath(VehicleprofileModule.turret_id))
            httpJSONResponseConfiguration.extractor = VehicleprofileModule.TurretExtractor()

            let pin = JointPin(modelClass: modelClass, identifier: turret_id, contextPredicate: map.contextPredicate)
            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
            httpRequestConfiguration.composer = MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder(pin: pin)

            #warning("move out of Decoder")
            let request = try appContext.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration, decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
            try appContext.requestManager?.startRequest(request!, listener: nil)
        }
    }
}

// MARK: - %t + VehicleprofileModuleJSONDecoder.VehicleprofileModuleJSONDecoderErrors

extension VehicleprofileModuleJSONDecoder {

    enum VehicleprofileModuleJSONDecoderErrors: Error, CustomStringConvertible {
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        public var description: String {
            switch self {
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            }
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
