//
//  ModulesTree+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension ModulesTree {
    override public func mapping(array: [Any], context: NSManagedObjectContext, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        print(array)
    }

    override public func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        // MARK: - CurrentModule

        let ruleBuilder = LinkedRemoteAsPrimaryRuleBuilder(parentObjectIDList: parentObjectIDList, linkedClazz: Module.self, linkedObjectID: module_id)
        let currentModuleHelper = ModulesTree.CurrentModuleLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        mappingCoordinator?.linkRemote(modelClazz: Module.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: ruleBuilder, keypathPrefix: nil, mapper: currentModuleHelper)

        // MARK: - NextModules

        let nextModulesHelper = ModulesTree.NextModulesLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let nextModules = json[#keyPath(ModulesTree.next_modules)] as? [AnyObject]
        nextModules?.forEach {
            let ruleBuilder = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(requestPredicate: requestPredicate, linkedClazz: Module.self, linkedObjectID: $0, parentObjectIDList: parentObjectIDList)
            mappingCoordinator?.linkRemote(modelClazz: Module.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: ruleBuilder, keypathPrefix: nil, mapper: nextModulesHelper)
        }

        // MARK: - NextTanks
        let nextTanksHelper = ModulesTree.NextVehicleLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let nextTanks = json[#keyPath(ModulesTree.next_tanks)]
        (nextTanks as? [AnyObject])?.forEach {
            // parents was not used for next portion of tanks
            let ruleBuilder = LinkedLocalAsPrimaryRuleBuilder(linkedClazz: Vehicles.self, linkedObjectID: $0)
            mappingCoordinator?.linkRemote(modelClazz: Vehicles.self, masterFetchResult: masterFetchResult, lookupRuleBuilder: ruleBuilder, keypathPrefix: nil, mapper: nextTanksHelper)
        }
    }
}

extension ModulesTree {
    public class CurrentModuleLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let module = fetchResult.managedObject() as? Module {
                if let modulesTree = masterFetchResult?.managedObject(inContext: context) as? ModulesTree {
                    modulesTree.currentModule = module
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class NextModulesLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            guard let modulesTree = masterFetchResult?.managedObject(inContext: context) as? ModulesTree else {
                completion(fetchResult, JSONAdapterLinkerError.wrongParentClass)
                return
            }
            guard let nextModule = fetchResult.managedObject() as? Module else {
                completion(fetchResult, JSONAdapterLinkerError.wrongChildClass)
                return
            }
            modulesTree.addToNext_modules(nextModule)
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class NextVehicleLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let tank = fetchResult.managedObject() as? Vehicles {
                if let modulesTree = masterFetchResult?.managedObject(inContext: context) as? ModulesTree {
                    modulesTree.addToNext_tanks(tank)
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
