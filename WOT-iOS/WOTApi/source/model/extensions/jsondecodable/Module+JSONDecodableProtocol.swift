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

        let parentsAsVehicles = map.contextPredicate.managedPins.compactMap {
            managedObjectContextContainer.managedObjectContext.object(managedPin: $0) as? Vehicles
        }
        let parents = parentsAsVehicles.compactMap { $0.tank_id }

        let moduleFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        guard !parents.isEmpty else {
            throw ModuleMappingError.noParentsFound
        }
        let tank_id = parents.first

        guard let module_id = module_id else {
            throw ModuleMappingError.moduleIdNotDefined
        }

        let hostPin = JointPin(modelClass: Vehicles.self, identifier: tank_id, contextPredicate: nil)

        let moduleDecoder = ModuleDecoder(appContext: appContext, hostPin: hostPin)
        moduleDecoder.module_id = module_id
        moduleDecoder.moduleFetchResult = moduleFetchResult
        moduleDecoder.type = type
        try moduleDecoder.decode()
    }
}

// MARK: - ModuleDecoder

public class ModuleDecoder {

    public let appContext: JSONDecodableProtocol.Context?
    public var modelClass: PrimaryKeypathProtocol.Type?
    public var module_id: NSDecimalNumber?
    public var moduleFetchResult: FetchResultProtocol?
    public let hostPin: JointPin
    public var type: String?

    init(appContext: JSONDecodableProtocol.Context?, hostPin: JointPin) {
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
            try fetch_module(appContext: appContext, modelClass: VehicleprofileGun.self, extractor: Module.GunExtractor(), module_id: module_id, keypath: #keyPath(Module.gun), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        case .vehicleRadio:
            try fetch_module(appContext: appContext, modelClass: VehicleprofileRadio.self, extractor: Module.RadioExtractor(), module_id: module_id, keypath: #keyPath(Module.radio), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        case .vehicleEngine:
            try fetch_module(appContext: appContext, modelClass: VehicleprofileEngine.self, extractor: Module.EngineExtractor(), module_id: module_id, keypath: #keyPath(Module.engine), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        case .vehicleChassis:
            try fetch_module(appContext: appContext, modelClass: VehicleprofileSuspension.self, extractor: Module.SuspensionExtractor(), module_id: module_id, keypath: #keyPath(Module.suspension), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        case .vehicleTurret:
            try fetch_module(appContext: appContext, modelClass: VehicleprofileTurret.self, extractor: Module.TurretExtractor(), module_id: module_id, keypath: #keyPath(Module.turret), moduleFetchResult: moduleFetchResult, hostPin: hostPin)
        }
    }

    private func fetch_module(appContext: JSONDecodableProtocol.Context?, modelClass: PrimaryKeypathProtocol.Type, extractor: ManagedObjectExtractable, module_id: NSDecimalNumber?, keypath: KeypathType, moduleFetchResult: FetchResultProtocol?, hostPin: JointPin) throws {
        let socket = JointSocket(identifier: module_id, keypath: keypath)
        let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: moduleFetchResult, socket: socket)
        let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)
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
