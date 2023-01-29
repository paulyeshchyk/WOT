//
//  ModulesTreeJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - ModulesTreeJSONDecoder

class ModulesTreeJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        //
        let moduleTreeJSON = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: moduleTreeJSON)

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: ModulesTreeJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        // MARK: - NextTanks

        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        if let nextTanks = moduleTreeJSON?[nextTanksKeypath] as? [JSONValueType] {
            for nextTank in nextTanks {
                fetchNextTank(tank_id: nextTank, decodingDepthLevel: decodingDepthLevel)
            }
        }

        // MARK: - NextModules

        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        if let nextModules = moduleTreeJSON?[nextModulesKeypath] as? [JSONValueType] {
            for nextModuleID in nextModules {
                fetchNextModule(nextModuleID: nextModuleID, map: map, decodingDepthLevel: decodingDepthLevel)
            }
        }

        // MARK: - CurrentModule

        let currentModuleKeypath = #keyPath(ModulesTree.module_id)
        if let identifier = moduleTreeJSON?[currentModuleKeypath] {
            fetchCurrentModule(identifier: identifier, map: map, moduleTreeJSON: moduleTreeJSON, decodingDepthLevel: decodingDepthLevel)
        }
    }

    private func fetchCurrentModule(identifier: JSONValueType?, map: JSONMapProtocol, moduleTreeJSON: JSON?, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            let managedRef: ManagedRefProtocol? = try managedObject?.managedRef()
            let modelClass: ModelClassType = Module.self
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()
            let socket: JointSocketProtocol = JointSocket(managedRef: managedRef!, identifier: nil, keypath: #keyPath(ModulesTree.currentModule))
            let extractor: ManagedObjectExtractable? = CurrentModuleExtractor()

            let pin: JointPinProtocol = JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: map.contextPredicate)
            let jsonRef: JSONRefProtocol = try JSONRef(data: moduleTreeJSON, modelClass: ModulesTree.self)
            let composer = LinkedRemoteAsPrimaryRuleBuilder(pin: pin, jsonRef: jsonRef)
            let contextPredicate = try composer.buildRequestPredicateComposition()

            let uow = UOWRemote(appContext: appContext)
            uow.modelClass = modelClass
            uow.modelFieldKeyPaths = modelFieldKeyPaths
            uow.socket = socket
            uow.extractor = extractor
            uow.contextPredicate = contextPredicate
            uow.nextDepthLevel = decodingDepthLevel?.nextDepthLevel
            appContext.uowManager.run(unit: uow) { _ in
                //
            }
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

    private func fetchNextModule(nextModuleID: JSONValueType?, map: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) {
        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        do {
            let managedRef = try managedObject?.managedRef()
            let modelClass = Module.self
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()
            let pin = JointPin(modelClass: modelClass, identifier: nextModuleID, contextPredicate: map.contextPredicate)
            let socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: nextModulesKeypath)
            let extractor = NextModuleExtractor()
            let nextDepthLevel = decodingDepthLevel?.nextDepthLevel
            let composer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(pin: pin)
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
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

    private func fetchNextTank(tank_id: JSONValueType?, decodingDepthLevel: DecodingDepthLevel?) {
        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        do {
            let managedRef = try managedObject?.managedRef()
            let modelClass = Vehicles.self
            let modelFieldKeyPaths = modelClass.fieldsKeypaths()
            let pin = JointPin(modelClass: Vehicles.self, identifier: tank_id, contextPredicate: nil)
            let socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: nextTanksKeypath)
            let extractor = NextVehicleExtractor()
            let nextDepthLevel = decodingDepthLevel?.nextDepthLevel
            let composer = LinkedLocalAsPrimaryRuleBuilder(pin: pin)
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
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
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

// MARK: - %t + ModulesTreeJSONDecoder.ModulesTreeJSONDecoderErrors

extension ModulesTreeJSONDecoder {

    enum ModulesTreeJSONDecoderErrors: Error, CustomStringConvertible {
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        public var description: String {
            switch self {
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            }
        }
    }
}
