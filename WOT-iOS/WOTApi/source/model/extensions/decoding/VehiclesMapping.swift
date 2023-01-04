//
//  Vehicles+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Vehicles {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let vehicleJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: vehicleJSON)
        //

        // MARK: - ModulesTree

        if let modulesTreeJSON = vehicleJSON[#keyPath(Vehicles.modules_tree)] as? JSON {
            try modulesTreeMapping(objectContext: managedObjectContextContainer.managedObjectContext, jSON: modulesTreeJSON, requestPredicate: map.predicate, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventMappingInfo(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id)), sender: self)
        }

        // MARK: - DefaultProfile

        let defaultProfileKeypath = #keyPath(Vehicles.default_profile)
        if let jsonElement = vehicleJSON[defaultProfileKeypath] as? JSON {
            let modelClass = Vehicleprofile.self
            let vehiclesFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)
            let builder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(Vehicleprofile.vehicles), parentObjectIDList: nil)
            let composition = try builder.buildRequestPredicateComposition()
            let collection = try JSONCollection(element: jsonElement)
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: defaultProfileKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehiclesFetchResult, anchor: anchor)
            let extractor = VehicleProfileManagedObjectCreator()
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: vehiclesFetchResult, byModelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventMappingInfo(error: VehiclesJSONMappingError.profileNotFound(tank_id)), sender: self)
        }
    }
}

extension Vehicles {
    private func modulesTreeMapping(objectContext: ManagedObjectContextProtocol, jSON: JSON?, requestPredicate: ContextPredicateProtocol, appContext: JSONDecodableProtocol.Context) throws {
        if let set = modules_tree {
            removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            throw VehiclesJSONMappingError.passedInvalidModuleTreeJSON(tank_id)
        }

        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(objectID)

        let vehiclesFetchResult = fetchResult(context: objectContext)

        let modulesTreePredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        modulesTreePredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        for key in moduleTreeJSON.keys {
            if let jsonElement = moduleTreeJSON[key] as? JSON {
                let module_id = jsonElement[#keyPath(ModulesTree.module_id)]

                let jsonCollection = try JSONCollection(element: jsonElement)
                try submoduleMapping(keypath: "<unknown3>", objectContext: objectContext, json: jsonCollection, module_id: module_id, requestPredicate: modulesTreePredicate, masterFetchResult: vehiclesFetchResult, inContext: appContext)
            } else {
                appContext.logInspector?.log(.warning(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id)))
            }
        }
    }

    private func submoduleMapping(keypath _: KeypathType, objectContext: ManagedObjectContextProtocol, json: JSONCollectionProtocol?, module_id: Any?, requestPredicate: ContextPredicateProtocol, masterFetchResult: FetchResultProtocol, inContext: JSONDecodableProtocol.Context) throws {
        guard let json = json else {
            throw VehiclesJSONMappingError.passedInvalidSubModuleJSON
        }
        guard let module_id = module_id as? NSNumber else {
            throw VehiclesJSONMappingError.passedInvalidModuleId
        }
        let submodulesPredicate = ContextPredicate(parentObjectIDList: requestPredicate.parentObjectIDList)
        submodulesPredicate[.primary] = ModulesTree.primaryKey(forType: .internal, andObject: module_id)
        submodulesPredicate[.secondary] = requestPredicate[.primary]
        let modelClass = ModulesTree.self
        let anchor = ManagedObjectLinkerAnchor(identifier: module_id, keypath: #keyPath(ModulesTree.next_modules))
        let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
        let extractor = ModulesTreeManagedObjectCreator()
        inContext.mappingCoordinator?.fetchLocalAndDecode(json: json, objectContext: objectContext, byModelClass: modelClass, contextPredicate: submodulesPredicate, managedObjectCreator: linker, managedObjectExtractor: extractor, appContext: inContext, completion: { _, _ in })
    }
}

// MARK: - VehiclesJSONMappingError

public enum VehiclesJSONMappingError: Error, CustomStringConvertible {
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
