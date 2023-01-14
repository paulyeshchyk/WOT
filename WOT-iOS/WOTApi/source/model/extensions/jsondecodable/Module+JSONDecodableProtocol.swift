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

        let filteredPin = map.contextPredicate.managedPins.filter { $0.modelClass == Vehicles.self }.first
        guard let hostPin = filteredPin?.getJointPin(idKeyPath: #keyPath(Vehicles.tank_id), inContext: managedObjectContextContainer.managedObjectContext) else {
            throw ModuleMappingError.noParentsFound
        }

        let moduleFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        guard let module_id = module_id else {
            throw ModuleMappingError.moduleIdNotDefined
        }

        let moduleDecoder = ModuleDecoder(appContext: appContext, parentHostPin: hostPin)
        moduleDecoder.module_id = module_id
        moduleDecoder.moduleFetchResult = moduleFetchResult
        moduleDecoder.type = type
        try moduleDecoder.decode()
    }
}

extension ManagedPinProtocol {

    func getJointPin(idKeyPath: KeypathType, inContext context: ManagedObjectContextProtocol) -> JointPinProtocol {
        let managedObject = context.object(managedPin: self)
        let identifier = managedObject?[idKeyPath]
        return JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: nil)
    }
}

// MARK: - ModuleDecoder

public class ModuleDecoder {

    public let appContext: JSONDecodableProtocol.Context?
    public var modelClass: PrimaryKeypathProtocol.Type?
    public var module_id: NSDecimalNumber?
    public var moduleFetchResult: FetchResultProtocol?
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
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.gun))
            let extractor = Module.GunExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, moduleFetchResult: moduleFetchResult, parentHostPin: parentHostPin)
        case .vehicleRadio:
            let pin = JointPin(modelClass: VehicleprofileRadio.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.radio))
            let extractor = Module.RadioExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, moduleFetchResult: moduleFetchResult, parentHostPin: parentHostPin)
        case .vehicleEngine:
            let pin = JointPin(modelClass: VehicleprofileEngine.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.engine))
            let extractor = Module.EngineExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, moduleFetchResult: moduleFetchResult, parentHostPin: parentHostPin)
        case .vehicleChassis:
            let pin = JointPin(modelClass: VehicleprofileSuspension.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.suspension))
            let extractor = Module.SuspensionExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, moduleFetchResult: moduleFetchResult, parentHostPin: parentHostPin)
        case .vehicleTurret:
            let pin = JointPin(modelClass: VehicleprofileTurret.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.turret))
            let extractor = Module.TurretExtractor()
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: extractor, moduleFetchResult: moduleFetchResult, parentHostPin: parentHostPin)
        }
    }

    private func fetch_module(appContext: JSONDecodableProtocol.Context?, pin: JointPinProtocol, socket: JointSocketProtocol, extractor: ManagedObjectExtractable, moduleFetchResult: FetchResultProtocol?, parentHostPin: JointPinProtocol) throws {
        let modelClass = pin.modelClass
        let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
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
