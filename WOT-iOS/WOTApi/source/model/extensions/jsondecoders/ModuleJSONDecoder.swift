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

        let filteredJsonRef = map.contextPredicate.jsonRefs.filter { $0.modelClass == Vehicles.self }.first
        guard let parentHostPin = try filteredJsonRef?.getJointPin(idKeyPath: #keyPath(Vehicles.tank_id)) else {
            throw ModuleJSONDecoderErrors.noParentsFound
        }

        guard let module_id = element?[#keyPath(Module.module_id)] else {
            throw ModuleJSONDecoderErrors.moduleIdNotDefined
        }

        let type = element?[#keyPath(Module.type)]

        #warning("move out of Decoder")
        let moduleDecoder = ModuleDecoder(appContext: appContext)
        moduleDecoder.module_id = module_id
        moduleDecoder.parentHostPin = parentHostPin
        moduleDecoder.type = type
        guard let managedRef = try managedObject?.managedRef() else {
            throw ModuleJSONDecoderErrors.invalidManagedRef
        }

        try moduleDecoder.decode(moduleManagedRef: managedRef, decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
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

// MARK: - ModuleDecoder

public class ModuleDecoder {

    typealias Context = LogInspectorContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    let appContext: Context
    public var modelClass: PrimaryKeypathProtocol.Type?
    public var module_id: JSONValueType?
    public var parentHostPin: JointPinProtocol?
    public var type: JSONValueType?

    init(appContext: Context) {
        self.appContext = appContext
    }

    deinit {
        //
    }

    func decode(moduleManagedRef: ManagedRefProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        let moduleType = try VehicleModuleType.fromString(type)
        switch moduleType {
        case .vehicleGun:
            let pin = JointPin(modelClass: VehicleprofileGun.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.gun))
            let extractor = Module.GunExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin, decodingDepthLevel: decodingDepthLevel)
        case .vehicleRadio:
            let pin = JointPin(modelClass: VehicleprofileRadio.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.radio))
            let extractor = Module.RadioExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin, decodingDepthLevel: decodingDepthLevel)
        case .vehicleEngine:
            let pin = JointPin(modelClass: VehicleprofileEngine.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.engine))
            let extractor = Module.EngineExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin, decodingDepthLevel: decodingDepthLevel)
        case .vehicleChassis:
            let pin = JointPin(modelClass: VehicleprofileSuspension.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.suspension))
            let extractor = Module.SuspensionExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin, decodingDepthLevel: decodingDepthLevel)
        case .vehicleTurret:
            let pin = JointPin(modelClass: VehicleprofileTurret.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.turret))
            let extractor = Module.TurretExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin, decodingDepthLevel: decodingDepthLevel)
        }
    }

    private func fetch_module(appContext: Context, pin: JointPinProtocol, socket: JointSocketProtocol, extractor: ManagedObjectExtractable, parentHostPin: JointPinProtocol?, decodingDepthLevel: DecodingDepthLevel?) throws {
        guard let parentHostPin = parentHostPin else {
            return
        }
        let modelClass = pin.modelClass
        let modelFieldKeyPaths = modelClass.fieldsKeypaths()
        let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, parentHostPin: parentHostPin)
        let nextDepthLevel = decodingDepthLevel

        let contextPredicate = try composer.buildRequestPredicateComposition()

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

// MARK: - ModuleJSONDecoder.ModuleJSONDecoderErrors

extension ModuleJSONDecoder {

    enum ModuleJSONDecoderErrors: Error, CustomStringConvertible {
        case noParentsFound
        case moduleIdNotDefined
        case invalidManagedRef
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        public var description: String {
            switch self {
            case .noParentsFound: return "[\(type(of: self))]: No parents found"
            case .moduleIdNotDefined: return "[\(type(of: self))]: module id is not defined"
            case .invalidManagedRef: return "[\(type(of: self))]: invalid managed ref"
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
