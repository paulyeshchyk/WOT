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

        fetch_module(keypath: #keyPath(VehicleprofileModule.gun_id),
                     idKeypath: #keyPath(VehicleprofileModule.gun_id),
                     modelClass: VehicleprofileGun.self,
                     contextPredicate: map.contextPredicate,
                     element: element,
                     extractor: VehicleprofileModule.GunExtractor(),
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        fetch_module(keypath: #keyPath(VehicleprofileModule.radio_id),
                     idKeypath: #keyPath(VehicleprofileModule.radio_id),
                     modelClass: VehicleprofileRadio.self,
                     contextPredicate: map.contextPredicate,
                     element: element,
                     extractor: VehicleprofileModule.RadioExtractor(),
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        fetch_module(keypath: #keyPath(VehicleprofileModule.engine_id),
                     idKeypath: #keyPath(VehicleprofileModule.engine_id),
                     modelClass: VehicleprofileEngine.self,
                     contextPredicate: map.contextPredicate,
                     element: element,
                     extractor: VehicleprofileModule.EngineExtractor(),
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        fetch_module(keypath: #keyPath(VehicleprofileModule.suspension_id),
                     idKeypath: #keyPath(VehicleprofileModule.suspension_id),
                     modelClass: VehicleprofileSuspension.self,
                     contextPredicate: map.contextPredicate,
                     element: element,
                     extractor: VehicleprofileModule.SuspensionExtractor(),
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        fetch_module(keypath: #keyPath(VehicleprofileModule.turret_id),
                     idKeypath: #keyPath(VehicleprofileModule.turret_id),
                     modelClass: VehicleprofileTurret.self,
                     contextPredicate: map.contextPredicate,
                     element: element,
                     extractor: VehicleprofileModule.TurretExtractor(),
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
    }

    private func fetch_module(keypath: AnyHashable, idKeypath: AnyHashable, modelClass: ModelClassType, contextPredicate: ContextPredicateProtocol, element: JSON, extractor: ManagedObjectExtractable, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileModuleJSONDecoderErrors.managedRefNotFound
            }
            guard let module_id = element[idKeypath] else {
                throw VehicleprofileModuleJSONDecoderErrors.idNotFound(idKeypath)
            }

            let socket = JointSocket(managedRef: managedRef, identifier: module_id, keypath: keypath)
            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: contextPredicate)

            let composerInput = ComposerInput()
            composerInput.pin = pin
            let composer = VehicleprofileModule_Composer()
            let contextPredicate = try? composer.build(composerInput)
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()

            let uow = UOWRemote(appContext: appContext)
            uow.modelClass = modelClass
            uow.modelFieldKeyPaths = modelFieldKeyPaths
            uow.socket = socket
            uow.extractor = extractor
            uow.contextPredicate = contextPredicate
            uow.nextDepthLevel = decodingDepthLevel
            appContext.uowManager.run(unit: uow) { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            }
        } catch {
            appContext.logInspector?.log(.warning(error: error), sender: self)
        }
    }
}

// MARK: - %t + VehicleprofileModuleJSONDecoder.VehicleprofileModuleJSONDecoderErrors

extension VehicleprofileModuleJSONDecoder {

    enum VehicleprofileModuleJSONDecoderErrors: Error, CustomStringConvertible {
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)
        case idNotFound(AnyHashable)
        case managedRefNotFound

        public var description: String {
            switch self {
            case .managedRefNotFound: return "[\(type(of: self))]: managedRef not found"
            case .idNotFound(let keypath): return "[\(type(of: self))]: id not found for (\(keypath))"
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
