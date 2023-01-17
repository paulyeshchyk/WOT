//
//  ModuleJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - ModuleJSONDecoder

class ModuleJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: JSONDecoderProtocol.Context?

    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    weak var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel _: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)
        //

        let filteredJsonRef = map.contextPredicate.jsonRefs.filter { $0.modelClass == Vehicles.self }.first
        guard let parentHostPin = filteredJsonRef?.getJointPin(idKeyPath: #keyPath(Vehicles.tank_id)) else {
            throw ModuleMappingError.noParentsFound
        }

        guard let module_id = element?[#keyPath(Module.module_id)] else {
            throw ModuleMappingError.moduleIdNotDefined
        }

        let type = element?[#keyPath(Module.type)]

        let moduleDecoder = ModuleDecoder(appContext: appContext)
        moduleDecoder.module_id = module_id
        moduleDecoder.parentHostPin = parentHostPin
        moduleDecoder.type = type
        try moduleDecoder.decode(moduleManagedRef: managedObject?.managedRef)
    }
}

extension ManagedRefProtocol {

    func getJointPin(idKeyPath: KeypathType, inContext context: ManagedObjectContextProtocol) -> JointPinProtocol {
        let managedObject = context.object(managedRef: self)
        let identifier = managedObject?[idKeyPath]
        return JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: nil)
    }
}

extension JSONRefProtocol {
    func getJointPin(idKeyPath: KeypathType) -> JointPinProtocol {
        let json = jsonCollection.data() as? JSON
        let identifier = json?[idKeyPath]
        return JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: nil)
    }

}

// MARK: - ModuleDecoder

public class ModuleDecoder {

    public weak var appContext: JSONDecoderProtocol.Context?
    public var modelClass: PrimaryKeypathProtocol.Type?
    public var module_id: JSONValueType?
    public var parentHostPin: JointPinProtocol?
    public var type: JSONValueType?

    init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    deinit {
        //
    }

    func decode(moduleManagedRef: ManagedRefProtocol?) throws {
        let moduleType = try VehicleModuleType.fromString(type)
        switch moduleType {
        case .vehicleGun:
            let pin = JointPin(modelClass: VehicleprofileGun.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.gun))
            let extractor = Module.GunExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin)
        case .vehicleRadio:
            let pin = JointPin(modelClass: VehicleprofileRadio.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.radio))
            let extractor = Module.RadioExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin)
        case .vehicleEngine:
            let pin = JointPin(modelClass: VehicleprofileEngine.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.engine))
            let extractor = Module.EngineExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin)
        case .vehicleChassis:
            let pin = JointPin(modelClass: VehicleprofileSuspension.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.suspension))
            let extractor = Module.SuspensionExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin)
        case .vehicleTurret:
            let pin = JointPin(modelClass: VehicleprofileTurret.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.turret))
            let extractor = Module.TurretExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, parentHostPin: parentHostPin)
        }
    }

    private func fetch_module(appContext: JSONDecoderProtocol.Context?, pin: JointPinProtocol, socket: JointSocketProtocol, extractor: ManagedObjectExtractable, parentHostPin: JointPinProtocol?) throws {
        guard let parentHostPin = parentHostPin else {
            return
        }

        let modelClass = pin.modelClass
        let linker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
        let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, parentHostPin: parentHostPin)
        let composition = try composer.buildRequestPredicateComposition()

        try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
    }
}

// MARK: - ModuleDecoder + RequestManagerListenerProtocol

extension ModuleDecoder: RequestManagerListenerProtocol {
    public var MD5: String {
        "ModuleDecoder"
    }

    public func requestManager(_: RequestManagerProtocol, didParseDataForRequest _: RequestProtocol, error _: Error?) {}
    public func requestManager(_: RequestManagerProtocol, didStartRequest _: RequestProtocol) {}
    public func requestManager(_: RequestManagerProtocol, didCancelRequest _: RequestProtocol, reason _: RequestCancelReasonProtocol) {}
}

// MARK: - ModuleMappingError

private enum ModuleMappingError: Error {
    case noParentsFound
    case moduleIdNotDefined
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
