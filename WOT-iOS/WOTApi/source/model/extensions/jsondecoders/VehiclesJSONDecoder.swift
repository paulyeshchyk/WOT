//
//  VehiclesJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehiclesJSONDecoder

class VehiclesJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context
    var jsonMap: JSONMapProtocol?
    var decodingDepthLevel: DecodingDepthLevel?

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode() throws {
        guard let map = jsonMap else {
            throw VehiclesJSONDecoderErrors.jsonMapNotDefined
        }
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: VehiclesJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - ModulesTree

        fetch_modulesTree(keypath: #keyPath(Vehicles.modules_tree),
                          idkeypath: #keyPath(ModulesTree.module_id),
                          nextLevelKeyPath: #keyPath(ModulesTree.next_modules),
                          modelClass: ModulesTree.self,
                          parentModelClass: Vehicles.self,
                          element: element,
                          contextPredicate: map.contextPredicate,
                          decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - DefaultProfile

        fetch_defaultProfile(keypath: #keyPath(Vehicles.default_profile),
                             parentKey: #keyPath(Vehicleprofile.vehicles),
                             modelClass: Vehicleprofile.self,
                             element: element,
                             contextPredicate: map.contextPredicate,
                             decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
    }

    private func fetch_modulesTree(keypath: AnyHashable, idkeypath: AnyHashable, nextLevelKeyPath: AnyHashable, modelClass: ModelClassType, parentModelClass: ModelClassType, element: JSON, contextPredicate: ContextPredicateProtocol, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let modulesTreeJSON = element[keypath] as? JSON else {
                throw VehiclesJSONDecoderErrors.elementNotFound(keypath)
            }
            let jsonRef = try JSONRef(data: element, modelClass: parentModelClass)

            Array(modulesTreeJSON.values).compactMap { $0 as? JSON }.forEach { jsonElement in
                fetch_subModuleTree(keypath: nextLevelKeyPath,
                                    idkeypath: idkeypath,
                                    modelClass: modelClass,
                                    jsonElement: jsonElement,
                                    contextPredicate: contextPredicate,
                                    jsonRef: jsonRef,
                                    decodingDepthLevel: decodingDepthLevel)
            }
        } catch {
            appContext.logInspector?.log(.warning(error: error), sender: self)
        }
    }

    private func fetch_subModuleTree(keypath: AnyHashable, idkeypath: AnyHashable, modelClass: ModelClassType, jsonElement: JSON, contextPredicate: ContextPredicateProtocol, jsonRef: JSONRefProtocol, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let module_id = jsonElement[idkeypath] else {
                throw VehiclesJSONDecoderErrors.idNotFound(idkeypath)
            }
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehiclesJSONDecoderErrors.managedRefNotFound
            }

            var parentJSONRefs = contextPredicate.jsonRefs
            parentJSONRefs.append(jsonRef)

            let parentComposerInput = ComposerInput()
            parentComposerInput.parentJSONRefs = parentJSONRefs
            parentComposerInput.contextPredicate = contextPredicate
            let parentComposer = VehiclesModuleTree_Composer()
            let parentContextPredicate = try parentComposer.build(parentComposerInput)

            let composerInput = ComposerInput()
            composerInput.pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: parentContextPredicate)
            let composer = ModulesTreeModule_Composer()
            let contextPredicate = try composer.build(composerInput)

            let socket = JointSocket(managedRef: managedRef, identifier: module_id, keypath: keypath)
            let jsonMap = try JSONMap(data: jsonElement, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            })
        } catch {
            appContext.logInspector?.log(.warning(error: error), sender: self)
        }
    }

    private func fetch_defaultProfile(keypath: AnyHashable, parentKey: String, modelClass: ModelClassType, element: JSON, contextPredicate: ContextPredicateProtocol, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehiclesJSONDecoderErrors.managedRefNotFound
            }
            guard let jsonElement = element[keypath] as? JSON else {
                throw VehiclesJSONDecoderErrors.elementNotFound(keypath)
            }
            let composerInput = ComposerInput()
            composerInput.contextPredicate = contextPredicate
            composerInput.parentKey = parentKey
            composerInput.parentJSONRefs = []
            let composer = ForeignKey_Composer()
            let contextPredicate = try composer.build(composerInput)

            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypath)
            let jsonMap = try JSONMap(data: jsonElement, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            })

        } catch {
            appContext.logInspector?.log(.warning(error: error), sender: self)
        }
    }
}

// MARK: - %t + VehiclesJSONDecoder.VehiclesJSONDecoderErrors

extension VehiclesJSONDecoder {

    enum VehiclesJSONDecoderErrors: Error, CustomStringConvertible {
        case jsonMapNotDefined
        case notAJSON
        case passedInvalidModuleTreeJSON(NSDecimalNumber?)
        case passedInvalidSubModuleJSON
        case passedInvalidModuleId
        case idNotFound(AnyHashable)
        case managedRefNotFound
        case elementNotFound(AnyHashable)
        case moduleTreeNotFound(NSDecimalNumber?)
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        public var description: String {
            switch self {
            case .jsonMapNotDefined: return "[\(type(of: self))]: JSONMap is not defined"
            case .managedRefNotFound: return "[\(type(of: self))]: ManagedRef not found"
            case .notAJSON: return "[\(type(of: self))]: Not a JSON"
            case .passedInvalidModuleTreeJSON(let profileID): return "[\(type(of: self))]: Passed invalid module tree json for \(profileID ?? -1)"
            case .passedInvalidSubModuleJSON: return "[\(type(of: self))]: Passed invalid submodule json"
            case .passedInvalidModuleId: return "[\(type(of: self))]: Passed invalid module id"
            case .idNotFound(let keypath): return "[\(type(of: self))]: id not found for (\(keypath))"
            case .elementNotFound(let keypath): return "[\(type(of: self))]: element not found for (\(keypath))"
            case .moduleTreeNotFound(let id): return "[\(type(of: self))]: Module tree is not defined in json for \(id ?? -1)"
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            }
        }
    }
}
