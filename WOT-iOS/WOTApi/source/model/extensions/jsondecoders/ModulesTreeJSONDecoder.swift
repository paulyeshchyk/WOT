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
            let managedRef = try managedObject?.managedRef()

            let modelClass = Module.self

            let jsonRef = try JSONRef(data: moduleTreeJSON, modelClass: ModulesTree.self)
            let pin = JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: map.contextPredicate)

            let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
            httpJSONResponseConfiguration.socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: #keyPath(ModulesTree.currentModule))
            httpJSONResponseConfiguration.extractor = CurrentModuleExtractor()

            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
            httpRequestConfiguration.composer = LinkedRemoteAsPrimaryRuleBuilder(pin: pin, jsonRef: jsonRef)

            let request = try appContext?.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration)
            try appContext?.requestManager?.startRequest(request!, listener: nil)
        } catch {
            appContext?.logInspector?.log(.error(error), sender: self)
        }
    }

    private func fetchNextModule(nextModuleID: JSONValueType?, map: JSONMapProtocol) {
        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        do {
            let managedRef = try managedObject?.managedRef()

            let modelClass = Module.self

            let pin = JointPin(modelClass: modelClass, identifier: nextModuleID, contextPredicate: map.contextPredicate)

            let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
            httpJSONResponseConfiguration.socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: nextModulesKeypath)
            httpJSONResponseConfiguration.extractor = NextModuleExtractor()

            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
            httpRequestConfiguration.composer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(pin: pin)

            let request = try appContext?.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration)

            try appContext?.requestManager?.startRequest(request!, listener: nil)
        } catch {
            appContext?.logInspector?.log(.error(error), sender: self)
        }
    }

    private func fetchNextTank(tank_id: JSONValueType?) {
        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        do {
            let managedRef = try managedObject?.managedRef()

            let modelClass = Vehicles.self
            // parents was not used for next portion of tanks
            let pin = JointPin(modelClass: Vehicles.self, identifier: tank_id, contextPredicate: nil)

            let httpJSONResponseConfiguration = HttpJSONResponseConfiguration(modelClass: modelClass)
            httpJSONResponseConfiguration.socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: nextTanksKeypath)
            httpJSONResponseConfiguration.extractor = NextVehicleExtractor()

            let httpRequestConfiguration = HttpRequestConfiguration(modelClass: modelClass)
            httpRequestConfiguration.modelFieldKeyPaths = modelClass.fieldsKeypaths()
            httpRequestConfiguration.composer = LinkedLocalAsPrimaryRuleBuilder(pin: pin)

            let request = try appContext?.requestRegistrator?.createRequest(requestConfiguration: httpRequestConfiguration, responseConfiguration: httpJSONResponseConfiguration)
            try appContext?.requestManager?.startRequest(request!, listener: nil)
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
