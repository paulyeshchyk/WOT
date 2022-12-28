//
//  Vehicles+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

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
        case .passedInvalidSubModuleJSON:  return "[\(type(of: self))]: Passed invalid submodule json"
        case .passedInvalidModuleId: return "[\(type(of: self))]: Passed invalid module id"
        case .profileNotFound(let id): return "[\(type(of: self))]: Profile not defined in json for \(id ?? -1)"
        case .moduleTreeNotFound(let id): return "[\(type(of: self))]: Module tree not defined in json for \(id ?? -1)"
        }
    }
}

extension Vehicles {
    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let vehicleJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try self.decode(decoderContainer: vehicleJSON)
        //

        // MARK: - ModulesTree

        if let modulesTreeJSON = vehicleJSON[#keyPath(Vehicles.modules_tree)] as? JSON {
            try self.modulesTreeMapping(objectContext: map.managedObjectContext, jSON: modulesTreeJSON, requestPredicate: map.predicate, inContext: inContext)
        } else {
            inContext.logInspector?.logEvent(EventMappingInfo(error: VehiclesJSONMappingError.moduleTreeNotFound(self.tank_id)), sender: self)
        }

        // MARK: - DefaultProfile

        if let defaultProfileJSON = vehicleJSON[#keyPath(Vehicles.default_profile)] as? JSON {
            let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)
            let builder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(Vehicleprofile.vehicles), parentObjectIDList: nil)
            let linker = Vehicles.DefaultProfileManagedObjectCreator.self
            let defaultProfileJSONCollection = try JSONCollection(element: defaultProfileJSON)
            inContext.mappingCoordinator?.linkItem(from: defaultProfileJSONCollection, masterFetchResult: masterFetchResult, linkedClazz: Vehicleprofile.self, managedObjectCreatorClass: linker, lookupRuleBuilder: builder, appContext: inContext)
        } else {
            inContext.logInspector?.logEvent(EventMappingInfo(error: VehiclesJSONMappingError.profileNotFound(self.tank_id)), sender: self)
        }
//
    }
}

extension Vehicles {
    private func modulesTreeMapping(objectContext: ManagedObjectContextProtocol, jSON: JSON?, requestPredicate: ContextPredicate, inContext: JSONMappableProtocol.Context) throws {
        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            throw VehiclesJSONMappingError.passedInvalidModuleTreeJSON(self.tank_id)
        }

        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehiclesFetchResult = FetchResult(objectContext: objectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        let modulesTreePredicate = ContextPredicate(parentObjectIDList: parentObjectIDList)
        modulesTreePredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        for key in moduleTreeJSON.keys {
            let json = moduleTreeJSON[key] as? JSON
            let module_id = json?[#keyPath(ModulesTree.module_id)]

            let jsonCollection = try JSONCollection(element: json)
            try submoduleMapping(objectContext: objectContext, json: jsonCollection, module_id: module_id, requestPredicate: modulesTreePredicate, masterFetchResult: vehiclesFetchResult, inContext: inContext)
        }
    }

    private func submoduleMapping(objectContext: ManagedObjectContextProtocol, json: JSONCollectable?, module_id: Any?, requestPredicate: ContextPredicate, masterFetchResult: FetchResult, inContext: JSONMappableProtocol.Context) throws {
        guard let json = json else {
            throw VehiclesJSONMappingError.passedInvalidSubModuleJSON
        }
        guard let module_id = module_id as? NSNumber else {
            throw VehiclesJSONMappingError.passedInvalidModuleId
        }
        let submodulesPredicate = ContextPredicate(parentObjectIDList: requestPredicate.parentObjectIDList)
        submodulesPredicate[.primary] = ModulesTree.primaryKey(forType: .internal, andObject: module_id)
        submodulesPredicate[.secondary] = requestPredicate[.primary]

        let linker = Vehicles.ModulesTreeManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
        inContext.mappingCoordinator?.fetchLocalAndDecode(json: json, objectContext: objectContext, forClass: ModulesTree.self, predicate: submodulesPredicate, managedObjectCreator: linker, appContext: inContext, completion: { _, _ in })
    }
}

extension Vehicles {
    public class ModulesTreeManagedObjectCreator: ManagedObjectCreator {
        private struct ModuleLinkerUnexpectedClassError: Error, CustomStringConvertible {
            var expected: AnyClass
            var received: AnyObject?
            public init(extected exp: AnyClass, received rec: AnyObject?) {
                self.expected = exp
                self.received = rec
            }

            var description: String {
                return "[ModuleLinkerUnexpectedClassError]: exprected (\(String(describing: expected))), received (\(String(describing: received ?? NSNull.self)))"
            }
        }

        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            guard let objectContext = fetchResult.managedObjectContext else {
                assertionFailure("object context is not defined")
                return
            }
            let childObject = fetchResult.managedObject()

            guard let modulesTree = childObject as? ModulesTree else {
                let error = ModuleLinkerUnexpectedClassError(extected: ModulesTree.self, received: childObject)
                completion(fetchResult, error)
                return
            }
            guard let vehicles = masterFetchResult?.managedObject(inManagedObjectContext: objectContext) as? Vehicles else {
                let received = masterFetchResult != nil ? Swift.type(of: masterFetchResult!) : nil
                let error = ModuleLinkerUnexpectedClassError(extected: Vehicles.self, received: received)
                completion(fetchResult, error)
                return
            }
            modulesTree.default_profile = vehicles.default_profile
            vehicles.addToModules_tree(modulesTree)
            dataStore?.stash(objectContext: objectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class DefaultProfileManagedObjectCreator: ManagedObjectCreator {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            guard let managedObjectContext = fetchResult.managedObjectContext else {
                assertionFailure("object context is not defined")
                return
            }
            guard let defaultProfile = fetchResult.managedObject() as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
                return
            }
            guard let vehicles = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicles else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
                return
            }
            vehicles.default_profile = defaultProfile
            vehicles.modules_tree?.forEach {
                ($0 as? ModulesTree)?.default_profile = defaultProfile
            }
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class VehiclesPivotDataManagedObjectCreator: ManagedObjectCreator {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            dataStore?.stash(objectContext: fetchResult.managedObjectContext, block: { error in
                completion(fetchResult, error)
            })
        }
    }

    public class VehiclesTreeManagedObjectCreator: ManagedObjectCreator {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            dataStore?.stash(objectContext: fetchResult.managedObjectContext, block: { error in
                completion(fetchResult, error)
            })
        }
    }
}
