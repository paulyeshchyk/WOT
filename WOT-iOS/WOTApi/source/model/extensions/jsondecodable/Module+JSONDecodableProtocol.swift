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

        let moduleDecoder = ModuleDecoder(appContext: appContext, hostPin: hostPin)
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
    public let hostPin: JointPinProtocol
    public var type: String?

    init(appContext: JSONDecodableProtocol.Context?, hostPin: JointPinProtocol) {
        self.appContext = appContext
        self.hostPin = hostPin
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
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: Module.GunExtractor(), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        case .vehicleRadio:
            let pin = JointPin(modelClass: VehicleprofileRadio.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.radio))
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: Module.RadioExtractor(), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        case .vehicleEngine:
            let pin = JointPin(modelClass: VehicleprofileEngine.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.engine))
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: Module.EngineExtractor(), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        case .vehicleChassis:
            let pin = JointPin(modelClass: VehicleprofileSuspension.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.suspension))
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: Module.SuspensionExtractor(), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        case .vehicleTurret:
            let pin = JointPin(modelClass: VehicleprofileTurret.self, identifier: module_id, contextPredicate: nil)
            let socket = JointSocket(identifier: module_id, keypath: #keyPath(Module.turret))
            try fetch_module(appContext: appContext, pin: pin, socket: socket, extractor: Module.TurretExtractor(), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        }
    }

    private func fetch_module(appContext: JSONDecodableProtocol.Context?, pin: JointPinProtocol, socket: JointSocketProtocol, extractor: ManagedObjectExtractable, moduleFetchResult: FetchResultProtocol?, hostPin: JointPinProtocol) throws {
        let modelClass = pin.modelClass
        let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
        let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, hostPin: hostPin)
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

extension Module {
    private func fetch_module(appContext: JSONDecodableProtocol.Context?, modelClass: PrimaryKeypathProtocol.Type, extractor: ManagedObjectExtractable, module_id: NSDecimalNumber, keypath: KeypathType, moduleFetchResult: FetchResultProtocol, hostPin: JointPin) throws {
        let socket = JointSocket(identifier: module_id, keypath: keypath)
        let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
        let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)
        let composer = MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder(pin: pin, hostPin: hostPin)
        let composition = try composer.buildRequestPredicateComposition()

        try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
    }
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
