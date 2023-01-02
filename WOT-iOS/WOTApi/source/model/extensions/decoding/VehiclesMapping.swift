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
            try modulesTreeMapping(objectContext: managedObjectContextContainer.managedObjectContext, jSON: modulesTreeJSON, requestPredicate: map.predicate, inContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventMappingInfo(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id)), sender: self)
        }

        // MARK: - DefaultProfile

        let defaultProfileKeypath = #keyPath(Vehicles.default_profile)
        if let jsonElement = vehicleJSON[defaultProfileKeypath] as? JSON {
            let modelClass = Vehicleprofile.self
            let masterFetchResult = FetchResult(objectID: objectID, inContext: managedObjectContextContainer.managedObjectContext, predicate: nil, fetchStatus: .recovered)
            let builder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(Vehicleprofile.vehicles), parentObjectIDList: nil)
            let composition = try builder.buildRequestPredicateComposition()
            let collection = try JSONCollection(element: jsonElement)
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: defaultProfileKeypath)
            let linker = VehicleProfileManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventMappingInfo(error: VehiclesJSONMappingError.profileNotFound(tank_id)), sender: self)
        }
    }
}

extension Vehicles {
    private func modulesTreeMapping(objectContext: ManagedObjectContextProtocol, jSON: JSON?, requestPredicate: ContextPredicateProtocol, inContext: JSONDecodableProtocol.Context) throws {
        if let set = modules_tree {
            removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            throw VehiclesJSONMappingError.passedInvalidModuleTreeJSON(tank_id)
        }

        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(objectID)

        let vehiclesFetchResult = FetchResult(objectID: objectID, inContext: objectContext, predicate: nil, fetchStatus: .recovered)

        let modulesTreePredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        modulesTreePredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        for key in moduleTreeJSON.keys {
            if let jsonElement = moduleTreeJSON[key] as? JSON {
                let module_id = jsonElement[#keyPath(ModulesTree.module_id)]

                let jsonCollection = try JSONCollection(element: jsonElement)
                try submoduleMapping(keypath: "<unknown3>", objectContext: objectContext, json: jsonCollection, module_id: module_id, requestPredicate: modulesTreePredicate, masterFetchResult: vehiclesFetchResult, inContext: inContext)
            } else {
                inContext.logInspector?.logEvent(EventWarning(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id), details: nil), sender: self)
            }
        }
    }

    private func submoduleMapping(keypath _: KeypathType, objectContext: ManagedObjectContextProtocol, json: JSONCollectionProtocol?, module_id: Any?, requestPredicate: ContextPredicateProtocol, masterFetchResult: FetchResult, inContext: JSONDecodableProtocol.Context) throws {
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
        let linker = ModulesTreeManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: anchor)
        inContext.mappingCoordinator?.fetchLocalAndDecode(json: json, objectContext: objectContext, byModelClass: modelClass, contextPredicate: submodulesPredicate, managedObjectCreator: linker, appContext: inContext, completion: { _, _ in })
    }
}

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
