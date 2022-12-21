//
//  ModulesTree+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension ModulesTree {
    override public func mapping(array: [Any], objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, mappingCoordinator: MappingCoordinatorProtocol, requestManager: RequestManagerProtocol) throws {
        print(array)
    }

    override public func mapping(json: JSON, objectContext: ManagedObjectContextProtocol, requestPredicate: RequestPredicate, mappingCoordinator: MappingCoordinatorProtocol, requestManager: RequestManagerProtocol) throws {
        //
//        try self.decode(json: json)
        //

        let masterFetchResult = FetchResult(objectContext: objectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - NextTanks

        let nextTanksJSONAdapter = ModulesTree.NextVehicleLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let nextTanks = json[#keyPath(ModulesTree.next_tanks)]
        (nextTanks as? [AnyObject])?.forEach {
            // parents was not used for next portion of tanks
            let nextTanksRequestPredicateComposer = LinkedLocalAsPrimaryRuleBuilder(linkedClazz: Vehicles.self, linkedObjectID: $0)
            let nextTanksRequestParadigm = MappingParadigm(clazz: Vehicles.self, adapter: nextTanksJSONAdapter, requestPredicateComposer: nextTanksRequestPredicateComposer, keypathPrefix: nil)
            requestManager.fetchRemote(paradigm: nextTanksRequestParadigm)
        }

        // MARK: - NextModules

        let nextModuleJSONAdapter = ModulesTree.NextModulesLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let nextModules = json[#keyPath(ModulesTree.next_modules)] as? [AnyObject]
        nextModules?.forEach {
            let nextModuleRequestPredicateComposer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: Module.self, linkedObjectID: $0, currentObjectID: self.objectID)
            let nextModuleRequestParadigm = MappingParadigm(clazz: Module.self, adapter: nextModuleJSONAdapter, requestPredicateComposer: nextModuleRequestPredicateComposer, keypathPrefix: nil)
            requestManager.fetchRemote(paradigm: nextModuleRequestParadigm)
        }

        // MARK: - CurrentModule

        let moduleJSONAdapter = ModulesTree.CurrentModuleLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let moduleRequestPredicateComposer = LinkedRemoteAsPrimaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: Module.self, linkedObjectID: module_id, currentObjectID: self.objectID)
        let moduleRequestParadigm = MappingParadigm(clazz: Module.self, adapter: moduleJSONAdapter, requestPredicateComposer: moduleRequestPredicateComposer, keypathPrefix: nil)
        requestManager.fetchRemote(paradigm: moduleRequestParadigm)
    }
}

extension ModulesTree {
    public class CurrentModuleLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let module = fetchResult.managedObject() as? Module {
                if let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? ModulesTree {
                    modulesTree.currentModule = module
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class NextModulesLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? ModulesTree else {
                completion(fetchResult, JSONAdapterLinkerError.wrongParentClass)
                return
            }
            guard let nextModule = fetchResult.managedObject() as? Module else {
                completion(fetchResult, JSONAdapterLinkerError.wrongChildClass)
                return
            }
            modulesTree.addToNext_modules(nextModule)
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class NextVehicleLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let tank = fetchResult.managedObject() as? Vehicles {
                if let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? ModulesTree {
                    modulesTree.addToNext_tanks(tank)
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
