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
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: ModulesTreeJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        // MARK: - NextTanks

        fetch_nextTank(keypath: #keyPath(ModulesTree.next_tanks),
                       modelClass: Vehicles.self,
                       element: element,
                       extractor: NextVehicleExtractor(),
                       decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - NextModules

        fetch_nextModule(keypath: #keyPath(ModulesTree.next_modules),
                         modelClass: Module.self,
                         element: element,
                         contextPredicate: map.contextPredicate,
                         extractor: NextModuleExtractor(),
                         decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - CurrentModule

        fetch_currentModule(keypath: #keyPath(ModulesTree.currentModule),
                            idkeypath: #keyPath(ModulesTree.module_id),
                            modelClass: Module.self,
                            element: element,
                            contextPredicate: map.contextPredicate,
                            extractor: CurrentModuleExtractor(),
                            decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
    }

    private func fetch_currentModule(keypath: AnyHashable, idkeypath: AnyHashable, modelClass: ModelClassType, element: JSON, contextPredicate: ContextPredicateProtocol, extractor: ManagedObjectExtractable?, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let module_id = element[idkeypath] else {
                throw ModulesTreeJSONDecoderErrors.idNotFound(idkeypath)
            }
            guard let managedRef = try managedObject?.managedRef() else {
                throw ModulesTreeJSONDecoderErrors.managedRefNotFound
            }
            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypath)
            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: contextPredicate)

            let composerInput = ComposerInput()
            composerInput.pin = pin
            let composer = ModulesTreeModule_Composer()
            let contextPredicate = try composer.build(composerInput)

            let uow = UOWRemote(appContext: appContext)
            uow.modelClass = modelClass
            uow.modelFieldKeyPaths = modelClass.fieldsKeypaths()
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

    private func fetch_nextModule(keypath: AnyHashable, modelClass: ModelClassType, element: JSON, contextPredicate: ContextPredicateProtocol, extractor: ManagedObjectExtractable, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let managedRef = try managedObject?.managedRef() else {
                throw ModulesTreeJSONDecoderErrors.managedRefNotFound
            }

            guard let nextModules = element[keypath] as? [JSONValueType] else {
                throw ModulesTreeJSONDecoderErrors.elementNotFound(keypath)
            }
            for module_id in nextModules {
                let modelFieldKeyPaths = modelClass.fieldsKeypaths()
                let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypath)

                let composerInput = ComposerInput()
                composerInput.pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: contextPredicate)
                let composer = ModulesTreeModule_Composer()
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
            }
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

    private func fetch_nextTank(keypath: AnyHashable, modelClass: ModelClassType, element: JSON, extractor: ManagedObjectExtractable, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let managedRef = try managedObject?.managedRef() else {
                throw ModulesTreeJSONDecoderErrors.managedRefNotFound
            }

            guard let nextTanks = element[keypath] as? [JSONValueType] else {
                throw ModulesTreeJSONDecoderErrors.elementNotFound(keypath)
            }
            for module_id in nextTanks {
                let modelFieldKeyPaths = modelClass.fieldsKeypaths()
                let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypath)
                let nextDepthLevel = decodingDepthLevel?.nextDepthLevel
                let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)

                let composerInput = ComposerInput()
                composerInput.pin = pin
                let composer = PrimaryKey_Composer()
                let contextPredicate = try composer.build(composerInput)

                let uow = UOWRemote(appContext: appContext)
                uow.modelClass = modelClass
                uow.modelFieldKeyPaths = modelFieldKeyPaths
                uow.socket = socket
                uow.extractor = extractor
                uow.contextPredicate = contextPredicate
                uow.nextDepthLevel = nextDepthLevel
                appContext.uowManager.run(unit: uow) { result in
                    if let error = result.error {
                        self.appContext.logInspector?.log(.error(error), sender: self)
                    }
                }
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
        case idNotFound(AnyHashable)
        case managedRefNotFound
        case elementNotFound(AnyHashable)

        public var description: String {
            switch self {
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            case .idNotFound(let keypath): return "[\(type(of: self))]: id not found for (\(keypath))"
            case .managedRefNotFound: return "[\(type(of: self))]: managedRef not found"
            case .elementNotFound(let keypath): return "[\(type(of: self))]: element not found for (\(keypath))"
            }
        }
    }
}
