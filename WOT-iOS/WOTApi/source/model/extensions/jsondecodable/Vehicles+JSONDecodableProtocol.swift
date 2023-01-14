//
//  Vehicles+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Vehicles {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        //
        let vehicleJSON = try map.data(ofType: JSON.self)
        try decode(decoderContainer: vehicleJSON)
        //

        // MARK: - ModulesTree

        if let modulesTreeJSON = vehicleJSON?[#keyPath(Vehicles.modules_tree)] as? JSON {
            try modulesTreeMapping(objectContext: managedObjectContextContainer.managedObjectContext, jSON: modulesTreeJSON, requestPredicate: map.contextPredicate, appContext: appContext)
        } else {
            appContext?.logInspector?.log(.warning(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id)), sender: self)
        }

        // MARK: - DefaultProfile

        let defaultProfileKeypath = #keyPath(Vehicles.default_profile)
        if let jsonElement = vehicleJSON?[defaultProfileKeypath] as? JSON {
            let modelClass = Vehicleprofile.self
            let vehiclesFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)
            let builder = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: #keyPath(Vehicleprofile.vehicles), managedPins: [])
            let composition = try builder.buildRequestPredicateComposition()
            let socket = JointSocket(identifier: composition.objectIdentifier, keypath: defaultProfileKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehiclesFetchResult, socket: socket)
            let managedObjectExtractor = DefaultProfileExtractor()
            let managedObjectContext = vehiclesFetchResult.managedObjectContext
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)

            MOSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, managedObjectContext: managedObjectContext, modelClass: modelClass, managedObjectLinker: managedObjectLinker, managedObjectExtractor: managedObjectExtractor, completion: { _, error in
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
    private func modulesTreeMapping(objectContext: ManagedObjectContextProtocol, jSON: JSON?, requestPredicate: ContextPredicateProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        if let set = modules_tree {
            removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            throw VehiclesJSONMappingError.passedInvalidModuleTreeJSON(tank_id)
        }

        var parentPins = requestPredicate.managedPins
        parentPins.append(objectID)

        let vehiclesFetchResult = fetchResult(context: objectContext)

        let contextPredicate = try VehiclesModuleTreeBuilder(requestPredicate: requestPredicate, managedPins: parentPins)
            .buildRequestPredicateComposition()
            .contextPredicate

        for key in moduleTreeJSON.keys {
            if let jsonElement = moduleTreeJSON[key] as? JSON {
                let module_id = jsonElement[#keyPath(ModulesTree.module_id)]

                try submoduleMapping(objectContext: objectContext, jsonElement: jsonElement, module_id: module_id, requestPredicate: contextPredicate, masterFetchResult: vehiclesFetchResult, appContext: appContext)
            } else {
                appContext?.logInspector?.log(.warning(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id)), sender: self)
            }
        }
    }

    private func submoduleMapping(objectContext: ManagedObjectContextProtocol, jsonElement: JSON, module_id: Any?, requestPredicate: ContextPredicateProtocol, masterFetchResult: FetchResultProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        let contextPredicate = try VehiclesModuleBuilder(requestPredicate: requestPredicate, module_id: module_id)
            .buildRequestPredicateComposition()
            .contextPredicate
        let modelClass = ModulesTree.self
        let socket = JointSocket(identifier: module_id, keypath: #keyPath(ModulesTree.next_modules))
        let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: masterFetchResult, socket: socket)
        let extractor = ModulesTreeExtractor()
        let jsonMap = try JSONMap(element: jsonElement, predicate: contextPredicate)
        MOSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, managedObjectContext: objectContext, modelClass: modelClass, managedObjectLinker: linker, managedObjectExtractor: extractor, completion: { _, _ in })
    }
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
