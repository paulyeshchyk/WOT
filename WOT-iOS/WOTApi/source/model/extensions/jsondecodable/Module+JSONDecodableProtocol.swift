//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Module {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, fetchResult: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        //
        let moduleJSON = try map.data(ofType: JSON.self)
        try decode(decoderContainer: moduleJSON)
        //

        let filteredManagedRef = map.contextPredicate.managedRefs.filter { $0.modelClass == Vehicles.self }.first
        guard let parentHostPin = filteredManagedRef?.getJointPin(idKeyPath: #keyPath(Vehicles.tank_id), inContext: fetchResult.managedObjectContext) else {
            throw ModuleMappingError.noParentsFound
        }

        guard let module_id = module_id else {
            throw ModuleMappingError.moduleIdNotDefined
        }

        let moduleDecoder = ModuleDecoder(appContext: appContext, parentHostPin: parentHostPin)
        moduleDecoder.module_id = module_id
        moduleDecoder.moduleManagedRef = managedRef
        moduleDecoder.type = type
        try moduleDecoder.decode()
    }
}

extension ManagedRefProtocol {

    func getJointPin(idKeyPath: KeypathType, inContext context: ManagedObjectContextProtocol) -> JointPinProtocol {
        let managedObject = context.object(managedRef: self)
        let identifier = managedObject?[idKeyPath]
        return JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: nil)
    }
}

// MARK: - ModuleDecoder

public class ModuleDecoder {

    public let appContext: JSONDecodableProtocol.Context?
    public var modelClass: PrimaryKeypathProtocol.Type?
    public var module_id: NSDecimalNumber?
    public var moduleManagedRef: ManagedRefProtocol?
    public let parentHostPin: JointPinProtocol
    public var type: String?

    init(appContext: JSONDecodableProtocol.Context?, parentHostPin: JointPinProtocol) {
        self.appContext = appContext
        self.parentHostPin = parentHostPin
    }

    deinit {
        //
    }

    func decode() throws {
        let moduleType = try VehicleModuleType.fromString(type)
        switch moduleType {
        case .vehicleGun:
            let pin = JointPin(modelClass: VehicleprofileGun.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.gun))
            let extractor = Module.GunExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, managedRef: moduleManagedRef, parentHostPin: parentHostPin)
        case .vehicleRadio:
            let pin = JointPin(modelClass: VehicleprofileRadio.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.radio))
            let extractor = Module.RadioExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, managedRef: moduleManagedRef, parentHostPin: parentHostPin)
        case .vehicleEngine:
            let pin = JointPin(modelClass: VehicleprofileEngine.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.engine))
            let extractor = Module.EngineExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, managedRef: moduleManagedRef, parentHostPin: parentHostPin)
        case .vehicleChassis:
            let pin = JointPin(modelClass: VehicleprofileSuspension.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.suspension))
            let extractor = Module.SuspensionExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, managedRef: moduleManagedRef, parentHostPin: parentHostPin)
        case .vehicleTurret:
            let pin = JointPin(modelClass: VehicleprofileTurret.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: moduleManagedRef, identifier: module_id, keypath: #keyPath(Module.turret))
            let extractor = Module.TurretExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, managedRef: moduleManagedRef, parentHostPin: parentHostPin)
        }
    }

    private func fetch_module(appContext: JSONDecodableProtocol.Context?, pin: JointPinProtocol, socket: JointSocketProtocol, extractor: ManagedObjectExtractable, managedRef _: ManagedRefProtocol?, parentHostPin: JointPinProtocol) throws {
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
