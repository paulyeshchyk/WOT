//
//  ModuleJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - ModuleJSONDecoder

class ModuleJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    weak var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: ModuleJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        #warning("remove jsonrefs; use map of parent request or try to parse elements['tanks']")
        let filteredJsonRef = map.contextPredicate.jsonRefs.filter { $0.modelClass == Vehicles.self }.first
        guard let parentHostPin = try filteredJsonRef?.getJointPin(idKeyPath: #keyPath(Vehicles.tank_id)) else {
            throw ModuleJSONDecoderErrors.noParentsFound
        }

        let type = element[#keyPath(Module.type)]
        let moduleType = try VehicleModuleType.fromString(type)

        switch moduleType {
        case .vehicleGun:
            fetch_module(keypath: #keyPath(Module.gun),
                         idkeypath: #keyPath(Module.module_id),
                         modelClass: VehicleprofileGun.self,
                         element: element,
                         extractor: Module.GunExtractor(),
                         parentHostPin: parentHostPin,
                         decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
        case .vehicleRadio:
            fetch_module(keypath: #keyPath(Module.radio),
                         idkeypath: #keyPath(Module.module_id),
                         modelClass: VehicleprofileRadio.self,
                         element: element,
                         extractor: Module.RadioExtractor(),
                         parentHostPin: parentHostPin,
                         decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
        case .vehicleEngine:
            fetch_module(keypath: #keyPath(Module.engine),
                         idkeypath: #keyPath(Module.module_id),
                         modelClass: VehicleprofileEngine.self,
                         element: element,
                         extractor: Module.EngineExtractor(),
                         parentHostPin: parentHostPin,
                         decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
        case .vehicleChassis:
            fetch_module(keypath: #keyPath(Module.suspension),
                         idkeypath: #keyPath(Module.module_id),
                         modelClass: VehicleprofileSuspension.self,
                         element: element,
                         extractor: Module.SuspensionExtractor(),
                         parentHostPin: parentHostPin,
                         decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
        case .vehicleTurret:
            fetch_module(keypath: #keyPath(Module.turret),
                         idkeypath: #keyPath(Module.module_id),
                         modelClass: VehicleprofileTurret.self,
                         element: element,
                         extractor: Module.TurretExtractor(),
                         parentHostPin: parentHostPin,
                         decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
        }
    }

    private func fetch_module(keypath: AnyHashable, idkeypath: AnyHashable, modelClass: ModelClassType, element: JSON, extractor: ManagedObjectExtractable, parentHostPin: JointPinProtocol?, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let parentHostPin = parentHostPin else {
                throw ModuleJSONDecoderErrors.parentHostPinNotDefined
            }
            guard let module_id = element[idkeypath] else {
                throw ModuleJSONDecoderErrors.moduleIdNotDefined
            }
            guard let managedRef = try managedObject?.managedRef() else {
                throw ModuleJSONDecoderErrors.invalidManagedRef
            }

            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)

            let socket = JointSocket(managedRef: managedRef, identifier: module_id, keypath: keypath)

            let modelFieldKeyPaths = modelClass.fieldsKeypaths()

            let composerInput = ComposerInput()
            composerInput.pin = pin
            composerInput.parentPin = parentHostPin
            let composer = Module_Composer()
            let contextPredicate = try composer.build(composerInput)

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
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

}

extension ManagedRefProtocol {
    func getJointPin(idKeyPath: KeypathType, inContext context: ManagedObjectContextProtocol) throws -> JointPinProtocol {
        let managedObject = try context.object(managedRef: self)
        let identifier = managedObject[idKeyPath]
        return JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: nil)
    }
}

extension JSONRefProtocol {
    func getJointPin(idKeyPath: KeypathType) throws -> JointPinProtocol {
        let json = jsonCollection.data() as? JSON
        let identifier = json?[idKeyPath]
        return JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: nil)
    }

}

// MARK: - ModuleJSONDecoder.ModuleJSONDecoderErrors

extension ModuleJSONDecoder {

    enum ModuleJSONDecoderErrors: Error, CustomStringConvertible {
        case noParentsFound
        case moduleIdNotDefined
        case invalidManagedRef
        case parentHostPinNotDefined
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        public var description: String {
            switch self {
            case .noParentsFound: return "[\(type(of: self))]: No parents found"
            case .moduleIdNotDefined: return "[\(type(of: self))]: module id is not defined"
            case .invalidManagedRef: return "[\(type(of: self))]: invalid managed ref"
            case .parentHostPinNotDefined: return "[\(type(of: self))]: parentHostPin is not defined"
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            }
        }
    }
}

extension Module {

    class EngineExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.engine) }
    }

    class GunExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.gun) }
    }

    class RadioExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.radio) }
    }

    class SuspensionExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.suspension) }
    }

    class TurretExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { #keyPath(Vehicleprofile.turret) }
    }
}
