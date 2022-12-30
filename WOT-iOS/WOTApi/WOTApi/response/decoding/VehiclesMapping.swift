//
//  Vehicles+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Vehicles {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let vehicleJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: vehicleJSON)
        //

        // MARK: - ModulesTree

        if let modulesTreeJSON = vehicleJSON[#keyPath(Vehicles.modules_tree)] as? JSON {
            try modulesTreeMapping(objectContext: map.managedObjectContext, jSON: modulesTreeJSON, requestPredicate: map.predicate, inContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventMappingInfo(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id)), sender: self)
        }

        // MARK: - DefaultProfile

        if let defaultProfileJSON = vehicleJSON[#keyPath(Vehicles.default_profile)] as? JSON {
            let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)
            let linker = DefaultProfileManagedObjectCreator.self
            let builder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(Vehicleprofile.vehicles), parentObjectIDList: nil)
            let defaultProfileJSONCollection = try JSONCollection(element: defaultProfileJSON)
            let composition = try builder.build()
            try appContext.mappingCoordinator?.linkItem(from: defaultProfileJSONCollection, masterFetchResult: masterFetchResult, linkedClazz: Vehicleprofile.self, managedObjectCreatorClass: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventMappingInfo(error: VehiclesJSONMappingError.profileNotFound(tank_id)), sender: self)
        }
    }
}

extension Vehicles {
    private func modulesTreeMapping(objectContext: ManagedObjectContextProtocol, jSON: JSON?, requestPredicate: ContextPredicate, inContext: JSONDecodableProtocol.Context) throws {
        if let set = modules_tree {
            removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            throw VehiclesJSONMappingError.passedInvalidModuleTreeJSON(tank_id)
        }

        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(objectID)

        let vehiclesFetchResult = FetchResult(objectContext: objectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        let modulesTreePredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        modulesTreePredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        for key in moduleTreeJSON.keys {
            if let json = moduleTreeJSON[key] as? JSON {
                let module_id = json[#keyPath(ModulesTree.module_id)]

                let jsonCollection = try JSONCollection(element: json)
                try submoduleMapping(objectContext: objectContext, json: jsonCollection, module_id: module_id, requestPredicate: modulesTreePredicate, masterFetchResult: vehiclesFetchResult, inContext: inContext)
            } else {
                inContext.logInspector?.logEvent(EventWarning(error: VehiclesJSONMappingError.moduleTreeNotFound(tank_id), details: nil), sender: self)
            }
        }
    }

    private func submoduleMapping(objectContext: ManagedObjectContextProtocol, json: JSONCollectable?, module_id: Any?, requestPredicate: ContextPredicate, masterFetchResult: FetchResult, inContext: JSONDecodableProtocol.Context) throws {
        guard let json = json else {
            throw VehiclesJSONMappingError.passedInvalidSubModuleJSON
        }
        guard let module_id = module_id as? NSNumber else {
            throw VehiclesJSONMappingError.passedInvalidModuleId
        }
        let submodulesPredicate = ContextPredicate(parentObjectIDList: requestPredicate.parentObjectIDList)
        submodulesPredicate[.primary] = ModulesTree.primaryKey(forType: .internal, andObject: module_id)
        submodulesPredicate[.secondary] = requestPredicate[.primary]

        let linker = ModulesTreeManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
        inContext.mappingCoordinator?.fetchLocalAndDecode(json: json, objectContext: objectContext, byModelClass: ModulesTree.self, predicate: submodulesPredicate, managedObjectCreator: linker, appContext: inContext, completion: { _, _ in })
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
