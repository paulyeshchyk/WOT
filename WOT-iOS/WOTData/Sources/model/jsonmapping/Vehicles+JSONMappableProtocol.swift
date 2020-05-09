//
//  Vehicles+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension Vehicles {
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        // MARK: - DefaultProfile

        let defaultProfileJSON = json[#keyPath(Vehicles.default_profile)] as? JSON
        let builder = ForeignAsPrimaryRuleBuilder(pkCase: pkCase, foreignSelectKey: #keyPath(Vehicleprofile.vehicles), parentObjectIDList: nil)
        let mapper = Vehicles.DefaultProfileLinker.self
        mappingCoordinator?.linkItem(from: defaultProfileJSON, masterFetchResult: masterFetchResult, linkedClazz: Vehicleprofile.self, mapperClazz: mapper, lookupRuleBuilder: builder)

        // MARK: - ModulesTree

        let modulesTreeJSON = json[#keyPath(Vehicles.modules_tree)] as? JSON
        self.modulesTreeMapping(context: context, jSON: modulesTreeJSON, pkCase: pkCase, mappingCoordinator: mappingCoordinator)
    }
}

extension Vehicles {
    private func modulesTreeMapping(context: NSManagedObjectContext, jSON: JSON?, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            return
        }

        var parentObjectIDList = pkCase.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehiclesFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        let modulesTreeCase = PKCase(parentObjectIDList: parentObjectIDList)
        modulesTreeCase[.primary] = pkCase[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        moduleTreeJSON.keys.forEach { key in
            guard let moduleTreeJSON = moduleTreeJSON[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber else { return }

            submoduleMapping(context: context, json: moduleTreeJSON, module_id: module_id, pkCase: modulesTreeCase, masterFetchResult: vehiclesFetchResult, mappingCoordinator: mappingCoordinator)
        }
    }

    private func submoduleMapping(context: NSManagedObjectContext, json: JSON, module_id: NSNumber, pkCase: PKCase, masterFetchResult: FetchResult, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
//        let ruleBuilder = MasterAsSecondaryLinkedLocalAsPrimaryRuleBuilder(pkCase: pkCase, linkedClazz: ModulesTree.self, linkedObjectID: module_id)
//        let mapperClazz = Vehicles.ModulesTreeLinker.self
//        mappingCoordinator?.linkItem(from: json, masterFetchResult: masterFetchResult, linkedClazz: ModulesTree.self, mapperClazz: mapperClazz, lookupRuleBuilder: ruleBuilder)

        let submodulesCase = PKCase(parentObjectIDList: pkCase.parentObjectIDList)
        submodulesCase[.primary] = ModulesTree.primaryKey(for: module_id, andType: .local)
        submodulesCase[.secondary] = pkCase[.primary]

        let mapper = Vehicles.ModulesTreeLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
        mappingCoordinator?.fetchLocal(json: json, context: context, forClass: ModulesTree.self, pkCase: submodulesCase, mapper: mapper) { _, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
            }
        }
    }
}

extension Vehicles {
    @available(*, deprecated, message: "change realization")
    public class VehiclesModulesTreeLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var primaryKeyType: PrimaryKeyType { return .remote }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let modulesTree = fetchResult.managedObject() as? ModulesTree {
                if let vehicles = masterFetchResult?.managedObject(inContext: context) as? Vehicles {
                    modulesTree.default_profile = vehicles.default_profile
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModulesTreeLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var primaryKeyType: PrimaryKeyType { return .remote }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let modulesTree = fetchResult.managedObject() as? ModulesTree {
                if let vehicles = masterFetchResult?.managedObject(inContext: context) as? Vehicles {
                    modulesTree.default_profile = vehicles.default_profile
                    vehicles.addToModules_tree(modulesTree)
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class DefaultProfileLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var primaryKeyType: PrimaryKeyType { return .remote }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let defaultProfile = fetchResult.managedObject() as? Vehicleprofile {
                if let vehicles = masterFetchResult?.managedObject(inContext: context) as? Vehicles {
                    vehicles.default_profile = defaultProfile
                    vehicles.modules_tree?.forEach {
                        ($0 as? ModulesTree)?.default_profile = defaultProfile
                    }
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehiclesPivotDataLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var primaryKeyType: PrimaryKeyType { return .local }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            coreDataStore?.stash(context: context, block: { error in
                completion(fetchResult, error)
            })
        }
    }
}
