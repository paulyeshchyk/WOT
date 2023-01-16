//
//  Vehicles+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Vehicles {

    // MARK: - JSONDecodableProtocol

    override func decode(using jsonMap: JSONMapProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        //
        let vehicleJSON = try jsonMap.data(ofType: JSON.self)
        try decode(decoderContainer: vehicleJSON)
        let jsonRef = try JSONRef(element: vehicleJSON, modelClass: Vehicles.self)
        //

        // MARK: - ModulesTree

        if let modulesTreeJSON = vehicleJSON?[#keyPath(Vehicles.modules_tree)] as? JSON {
            if let set = modules_tree {
                removeFromModules_tree(set)
            }

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
                    let socket = JointSocket(managedRef: managedRef, identifier: module_id, keypath: keypath)
                    let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
                    let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
                    JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, completion: { _, error in
                        if let error = error {
                            appContext?.logInspector?.log(.warning(error: error), sender: self)
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
        if let jsonElement = vehicleJSON?[defaultProfileKeypath] as? JSON {
            let foreignSelectKey = #keyPath(Vehicleprofile.vehicles)
            let modelClass = Vehicleprofile.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: jsonMap, foreignSelectKey: foreignSelectKey, jsonRefs: [])
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedRef, identifier: composition.objectIdentifier, keypath: defaultProfileKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehiclesJSONMappingError.profileNotFound(tank_id)), sender: self)
        }
    }
}

extension Vehicles {
    private func modulesTreeMapping(modulesTreeJSON _: JSON?, jsonRef _: JSONRefProtocol, jsonMap _: JSONMapProtocol, appContext _: JSONDecodableProtocol.Context?) throws {}
}

extension Vehicles {

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
        case .profileNotFound(let id): return "[\(type(of: self))]: Profile not defined in json for \(id ?? -1)"
        case .moduleTreeNotFound(let id): return "[\(type(of: self))]: Module tree not defined in json for \(id ?? -1)"
        }
    }
}
