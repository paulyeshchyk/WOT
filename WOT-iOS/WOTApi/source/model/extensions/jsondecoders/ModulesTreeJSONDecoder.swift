//
//  ModulesTreeJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - ModulesTreeJSONDecoder

class ModulesTreeJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: JSONDecoderProtocol.Context?

    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel _: DecodingDepthLevel?) throws {
        //
        let moduleTreeJSON = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: moduleTreeJSON)
        //

        // MARK: - NextTanks

        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        if let nextTanks = moduleTreeJSON?[nextTanksKeypath] as? [JSONValueType] {
            for nextTank in nextTanks {
                fetchNextTank(tank_id: nextTank)
            }
        }

        // MARK: - NextModules

        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        if let nextModules = moduleTreeJSON?[nextModulesKeypath] as? [JSONValueType] {
            for nextModuleID in nextModules {
                fetchNextModule(nextModuleID: nextModuleID, map: map)
            }
        }

        // MARK: - CurrentModule

        let currentModuleKeypath = #keyPath(ModulesTree.module_id)
        if let identifier = moduleTreeJSON?[currentModuleKeypath] {
            fetchCurrentModule(identifier: identifier, map: map, moduleTreeJSON: moduleTreeJSON)
        }
    }

    private func fetchCurrentModule(identifier: JSONValueType?, map: JSONMapProtocol, moduleTreeJSON: JSON?) {
        do {
            let jsonRef = try JSONRef(data: moduleTreeJSON, modelClass: ModulesTree.self)
            let currentModuleKeypath = #keyPath(ModulesTree.currentModule)
            let modelClass = Module.self
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: currentModuleKeypath)
            let extractor = CurrentModuleExtractor()
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass)
            managedObjectLinker.socket = socket

            let pin = JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: map.contextPredicate)
            let composer = LinkedRemoteAsPrimaryRuleBuilder(pin: pin, jsonRef: jsonRef)
            let composition = try composer.buildRequestPredicateComposition()

            let request = try appContext?.requestManager?.createRequest(modelClass: modelClass, contextPredicate: composition.contextPredicate)
            try appContext?.requestManager?.startRequest(request!, managedObjectLinker: managedObjectLinker, managedObjectExtractor: extractor, listener: nil)
        } catch {
            appContext?.logInspector?.log(.error(error), sender: self)
        }
    }

    private func fetchNextModule(nextModuleID: JSONValueType?, map: JSONMapProtocol) {
        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        do {
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: nextModulesKeypath)
            let linker = ManagedObjectLinker(modelClass: ModulesTree.self)
            linker.socket = socket

            let extractor = NextModuleExtractor()
            let modelClass = Module.self

            let pin = JointPin(modelClass: modelClass, identifier: nextModuleID, contextPredicate: map.contextPredicate)
            let composer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()

            let request = try appContext?.requestManager?.createRequest(modelClass: modelClass, contextPredicate: composition.contextPredicate)

            try appContext?.requestManager?.startRequest(request!, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: nil)
        } catch {
            appContext?.logInspector?.log(.error(error), sender: self)
        }
    }

    private func fetchNextTank(tank_id: JSONValueType?) {
        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        do {
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: nextTanksKeypath)
            let linker = ManagedObjectLinker(modelClass: Vehicles.self)
            linker.socket = socket

            let extractor = NextVehicleExtractor()
            // parents was not used for next portion of tanks
            let pin = JointPin(modelClass: Vehicles.self, identifier: tank_id, contextPredicate: nil)
            let composer = LinkedLocalAsPrimaryRuleBuilder(pin: pin)
            let modelClass = Vehicles.self
            let composition = try composer.buildRequestPredicateComposition()

            let request = try appContext?.requestManager?.createRequest(modelClass: modelClass, contextPredicate: composition.contextPredicate)
            try appContext?.requestManager?.startRequest(request!, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: nil)
        } catch {
            appContext?.logInspector?.log(.error(error), sender: self)
        }
    }

}

extension ModulesTreeJSONDecoder {

    private class NextVehicleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class NextModuleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class CurrentModuleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }
}
