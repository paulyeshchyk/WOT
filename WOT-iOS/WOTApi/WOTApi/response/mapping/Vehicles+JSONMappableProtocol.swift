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

extension Vehicles {
    override public func mapping(json: JSON, objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, mappingCoordinator: MappingCoordinatorProtocol, requestManager: RequestManagerProtocol) throws {
        //
        try self.decode(json: json)
        //
        let masterFetchResult = FetchResult(objectContext: objectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - DefaultProfile

        let defaultProfileJSON = json[#keyPath(Vehicles.default_profile)] as? JSON
        let builder = ForeignAsPrimaryRuleBuilder(requestPredicate: requestPredicate, foreignSelectKey: #keyPath(Vehicleprofile.vehicles), parentObjectIDList: nil)
        let linker = Vehicles.DefaultProfileLinker.self
        mappingCoordinator.linkItem(from: defaultProfileJSON, masterFetchResult: masterFetchResult, linkedClazz: Vehicleprofile.self, mapperClazz: linker, lookupRuleBuilder: builder, requestManager: requestManager)

        // MARK: - ModulesTree

        let modulesTreeJSON = json[#keyPath(Vehicles.modules_tree)] as? JSON
        self.modulesTreeMapping(objectContext: objectContext, jSON: modulesTreeJSON, requestPredicate: requestPredicate, mappingCoordinator: mappingCoordinator, requestManager: requestManager)
    }
}

extension Vehicles {
    private func modulesTreeMapping(objectContext: ManagedObjectContextProtocol, jSON: JSON?, requestPredicate: RequestPredicate, mappingCoordinator: MappingCoordinatorProtocol?, requestManager: RequestManagerProtocol) {
        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            return
        }

        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehiclesFetchResult = FetchResult(objectContext: objectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        let modulesTreePredicate = RequestPredicate(parentObjectIDList: parentObjectIDList)
        modulesTreePredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        moduleTreeJSON.keys.forEach { key in
            guard let moduleTreeJSON = moduleTreeJSON[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber else { return }

            submoduleMapping(objectContext: objectContext, json: moduleTreeJSON, module_id: module_id, requestPredicate: modulesTreePredicate, masterFetchResult: vehiclesFetchResult, mappingCoordinator: mappingCoordinator, requestManager: requestManager)
        }
    }

    private func submoduleMapping(objectContext: ManagedObjectContextProtocol, json: JSON, module_id: NSNumber, requestPredicate: RequestPredicate, masterFetchResult: FetchResult, mappingCoordinator: MappingCoordinatorProtocol?, requestManager: RequestManagerProtocol) {
        let submodulesPredicate = RequestPredicate(parentObjectIDList: requestPredicate.parentObjectIDList)
        submodulesPredicate[.primary] = ModulesTree.primaryKey(for: module_id, andType: .internal)
        submodulesPredicate[.secondary] = requestPredicate[.primary]

        let linker = Vehicles.ModulesTreeLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
        mappingCoordinator?.fetchLocalAndDecode(json: json, objectContext: objectContext, forClass: ModulesTree.self, requestPredicate: submodulesPredicate, linker: linker, requestManager: requestManager, completion: { _, _ in })
    }
}

extension Vehicles {
    public class ModulesTreeLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            guard let objectContext = fetchResult.objectContext else {
                assertionFailure("object context is not defined")
                return
            }
            let childObject = fetchResult.managedObject()

            guard let modulesTree = childObject as? ModulesTree else {
                let error = UnexpectedClassError(extected: ModulesTree.self, received: childObject)
                completion(fetchResult, error)
                return
            }
            guard let vehicles = masterFetchResult?.managedObject(inManagedObjectContext: objectContext) as? Vehicles else {
                let received = masterFetchResult != nil ? Swift.type(of: masterFetchResult!) : nil
                let error = UnexpectedClassError(extected: Vehicles.self, received: received)
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

    public class DefaultProfileLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            guard let managedObjectContext = fetchResult.objectContext else {
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

    public class VehiclesPivotDataLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            dataStore?.stash(objectContext: fetchResult.objectContext, block: { error in
                completion(fetchResult, error)
            })
        }
    }

    public class VehiclesTreeViewLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            dataStore?.stash(objectContext: fetchResult.objectContext, block: { error in
                completion(fetchResult, error)
            })
        }
    }
}