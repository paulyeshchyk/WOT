//
//  VehiclesJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehiclesJSONDecoder

class VehiclesJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: JSONDecoderProtocol.Context?

    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using jsonMap: JSONMapProtocol, forDepthLevel: DecodingDepthLevel?) throws {
        //
        let element = try jsonMap.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)
        let jsonRef = try JSONRef(data: element, modelClass: Vehicles.self)
        //

        let tank_id = element?[#keyPath(Vehicles.tank_id)] as? NSDecimalNumber

        // MARK: - ModulesTree

        if let modulesTreeJSON = element?[#keyPath(Vehicles.modules_tree)] as? JSON {
            var parentJSONRefs = jsonMap.contextPredicate.jsonRefs
            parentJSONRefs.append(jsonRef)

            let composer = VehiclesModuleTreeBuilder(jsonMap: jsonMap, jsonRefs: parentJSONRefs)
            let contextPredicate = try composer.buildRequestPredicateComposition().contextPredicate

            for key in modulesTreeJSON.keys {
                if let jsonElement = modulesTreeJSON[key] as? JSON {
                    let module_id = jsonElement[#keyPath(ModulesTree.module_id)]

                    let composer = VehiclesModuleBuilder(requestPredicate: contextPredicate, module_id: module_id)
                    let composition = try composer.buildRequestPredicateComposition()
                    let keypath = #keyPath(ModulesTree.next_modules)
                    let modelClass = ModulesTree.self
                    let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: module_id, keypath: keypath)
                    let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
                    let jsonMap = try JSONMap(data: jsonElement, predicate: composition.contextPredicate)
                    let decodingDepthLevel = forDepthLevel?.next

                    JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                        if let error = error {
                            self.appContext?.logInspector?.log(.warning(error: error), sender: self)
                        }
                    })
                } else {
                    appContext?.logInspector?.log(.warning(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id)), sender: self)
                }
            }
        } else {
            appContext?.logInspector?.log(.warning(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id)), sender: self)
        }

        // MARK: - DefaultProfile

        let defaultProfileKeypath = #keyPath(Vehicles.default_profile)
        if let jsonElement = element?[defaultProfileKeypath] as? JSON {
            let foreignSelectKey = #keyPath(Vehicleprofile.vehicles)
            let modelClass = Vehicleprofile.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: jsonMap, foreignSelectKey: foreignSelectKey, jsonRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: defaultProfileKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(data: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    self.appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehiclesJSONMappingError.profileNotFound(tank_id)), sender: self)
        }
    }
}

extension VehiclesJSONDecoder {
    private func modulesTreeMapping(modulesTreeJSON _: JSON?, jsonRef _: JSONRefProtocol, jsonMap _: JSONMapProtocol, appContext _: JSONDecoderProtocol.Context?) throws {}
}

extension VehiclesJSONDecoder {

    public class DefaultProfileExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class ModulesTreeExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }

    }
}

// MARK: - VehiclesJSONMappingError

private enum VehiclesJSONMappingError: Error, CustomStringConvertible {
    case notAJSON
    case passedInvalidModuleTreeJSON(NSDecimalNumber?)
    case passedInvalidSubModuleJSON
    case passedInvalidModuleId
    case profileNotFound(NSDecimalNumber?)
    case moduleTreeNotFound(NSDecimalNumber?)

    public var description: String {
        switch self {
        case .notAJSON: return "[\(type(of: self))]: Not a JSON"
        case .passedInvalidModuleTreeJSON(let profileID): return "[\(type(of: self))]: Passed invalid module tree json for \(profileID ?? -1)"
        case .passedInvalidSubModuleJSON: return "[\(type(of: self))]: Passed invalid submodule json"
        case .passedInvalidModuleId: return "[\(type(of: self))]: Passed invalid module id"
        case .profileNotFound(let id): return "[\(type(of: self))]: Profile is not defined in json for \(id ?? -1)"
        case .moduleTreeNotFound(let id): return "[\(type(of: self))]: Module tree is not defined in json for \(id ?? -1)"
        }
    }
}
