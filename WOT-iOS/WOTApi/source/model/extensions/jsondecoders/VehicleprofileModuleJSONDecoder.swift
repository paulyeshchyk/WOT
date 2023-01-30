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

        if let gun_id = element[#keyPath(VehicleprofileModule.gun_id)] {
            //
            let managedRef = try managedObject?.managedRef()
            let modelClass = VehicleprofileGun.self
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()
            let pin = JointPin(modelClass: modelClass, identifier: gun_id, contextPredicate: map.contextPredicate)
            let socket = JointSocket(managedRef: managedRef!, identifier: gun_id, keypath: #keyPath(VehicleprofileModule.gun_id))
            let extractor = VehicleprofileModule.GunExtractor()
            let nextDepthLevel = decodingDepthLevel?.nextDepthLevel
            let composer = VehicleprofileModule_Composer(pin: pin)
            let contextPredicate = try? composer.buildRequestPredicateComposition()

            let uow = UOWRemote(appContext: appContext)
            uow.modelClass = modelClass
            uow.modelFieldKeyPaths = modelFieldKeyPaths
            uow.socket = socket
            uow.extractor = extractor
            uow.contextPredicate = contextPredicate
            uow.nextDepthLevel = nextDepthLevel
            appContext.uowManager.run(unit: uow) { _ in
                //
            }
        }

        if let radio_id = element[#keyPath(VehicleprofileModule.radio_id)] {
            //
            let managedRef = try managedObject?.managedRef()
            let modelClass = VehicleprofileRadio.self
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()
            let pin = JointPin(modelClass: modelClass, identifier: radio_id, contextPredicate: map.contextPredicate)
            let socket = JointSocket(managedRef: managedRef!, identifier: radio_id, keypath: #keyPath(VehicleprofileModule.radio_id))
            let extractor = VehicleprofileModule.RadioExtractor()
            let nextDepthLevel = decodingDepthLevel?.nextDepthLevel
            let composer = VehicleprofileModule_Composer(pin: pin)
            let contextPredicate = try? composer.buildRequestPredicateComposition()

            let uow = UOWRemote(appContext: appContext)
            uow.modelClass = modelClass
            uow.modelFieldKeyPaths = modelFieldKeyPaths
            uow.socket = socket
            uow.extractor = extractor
            uow.contextPredicate = contextPredicate
            uow.nextDepthLevel = nextDepthLevel
            appContext.uowManager.run(unit: uow) { _ in
                //
            }
        }

        if let engine_id = element[#keyPath(VehicleprofileModule.engine_id)] {
            //
            let managedRef = try managedObject?.managedRef()
            let modelClass = VehicleprofileEngine.self
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()
            let pin = JointPin(modelClass: modelClass, identifier: engine_id, contextPredicate: map.contextPredicate)
            let socket = JointSocket(managedRef: managedRef!, identifier: engine_id, keypath: #keyPath(VehicleprofileModule.engine_id))
            let extractor = VehicleprofileModule.EngineExtractor()
            let nextDepthLevel = decodingDepthLevel?.nextDepthLevel
            let composer = VehicleprofileModule_Composer(pin: pin)
            let contextPredicate = try? composer.buildRequestPredicateComposition()

            let uow = UOWRemote(appContext: appContext)
            uow.modelClass = modelClass
            uow.modelFieldKeyPaths = modelFieldKeyPaths
            uow.socket = socket
            uow.extractor = extractor
            uow.contextPredicate = contextPredicate
            uow.nextDepthLevel = nextDepthLevel
            appContext.uowManager.run(unit: uow) { _ in
                //
            }
        }

        if let suspension_id = element[#keyPath(VehicleprofileModule.suspension_id)] {
            //
            let managedRef = try managedObject?.managedRef()
            let modelClass = VehicleprofileSuspension.self
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()
            let pin = JointPin(modelClass: modelClass, identifier: suspension_id, contextPredicate: map.contextPredicate)
            let socket = JointSocket(managedRef: managedRef!, identifier: suspension_id, keypath: #keyPath(VehicleprofileModule.suspension_id))
            let extractor = VehicleprofileModule.SuspensionExtractor()
            let nextDepthLevel = decodingDepthLevel?.nextDepthLevel
            let composer = VehicleprofileModule_Composer(pin: pin)
            let contextPredicate = try? composer.buildRequestPredicateComposition()

            let uow = UOWRemote(appContext: appContext)
            uow.modelClass = modelClass
            uow.modelFieldKeyPaths = modelFieldKeyPaths
            uow.socket = socket
            uow.extractor = extractor
            uow.contextPredicate = contextPredicate
            uow.nextDepthLevel = nextDepthLevel
            appContext.uowManager.run(unit: uow) { _ in
                //
            }
        }

        if let turret_id = element[#keyPath(VehicleprofileModule.turret_id)] {
            //
            let modelClass = VehicleprofileTurret.self
            let managedRef = try managedObject?.managedRef()
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()
            let pin = JointPin(modelClass: modelClass, identifier: turret_id, contextPredicate: map.contextPredicate)
            let socket = JointSocket(managedRef: managedRef!, identifier: turret_id, keypath: #keyPath(VehicleprofileModule.turret_id))
            let extractor = VehicleprofileModule.TurretExtractor()
            let nextDepthLevel = decodingDepthLevel?.nextDepthLevel
            let composer = VehicleprofileModule_Composer(pin: pin)
            let contextPredicate = try? composer.buildRequestPredicateComposition()

            let uow = UOWRemote(appContext: appContext)
            uow.modelClass = modelClass
            uow.modelFieldKeyPaths = modelFieldKeyPaths
            uow.socket = socket
            uow.extractor = extractor
            uow.contextPredicate = contextPredicate
            uow.nextDepthLevel = nextDepthLevel
            appContext.uowManager.run(unit: uow) { _ in
                //
            }
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
