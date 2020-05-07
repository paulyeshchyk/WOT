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
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        var parentObjectIDList = pkCase.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        // MARK: - CurrentModule

        let currentModuleHelper = ModulesTree.ModulesTreeCurrentModuleLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        let currentModulePK = PKCase(parentObjectIDList: parentObjectIDList)
        currentModulePK[.primary] = Module.primaryKey(for: self.module_id as AnyObject, andType: .external)
        mappingCoordinator?.fetchRemote(context: context, byModelClass: Module.self, pkCase: currentModulePK, keypathPrefix: nil, linker: currentModuleHelper)

        // MARK: - NextModules

        let nextModulesHelper = ModulesTree.ModulesTreeNextModulesLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        let nextModules = json[#keyPath(ModulesTree.next_modules)] as? [AnyObject]
        nextModules?.forEach {
            let modulePK = PKCase(parentObjectIDList: parentObjectIDList)
            modulePK[.primary] = pkCase[.primary]
            modulePK[.secondary] = Module.primaryKey(for: $0, andType: .external)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: Module.self, pkCase: modulePK, keypathPrefix: nil, linker: nextModulesHelper)
        }

        #warning("Next Tanks")
//        // MARK: - NextTanks
//        let nextTanksHelper = ModulesTree.ModulesTreeNextVehicleLinker(objectID: self.objectID, identifier: nil, persistentStore: persistentStore)
//        let nextTanks = jSON[#keyPath(ModulesTree.next_tanks)]
//        (nextTanks as? [AnyObject])?.forEach {
//            // parents was not used for next portion of tanks
//            let nextTanksPK = PKCase(parentObjects: nil)
//            nextTanksPK[.primary] = Vehicles.primaryKey(for: $0, andType: .internal)
//            persistentStore?.fetchRemote(context: context, byModelClass: Vehicles.self, pkCase: nextTanksPK, keypathPrefix: nil, linker: nextTanksHelper)
//        }
    }
}

extension ModulesTree {
    public class ModulesTreeCurrentModuleLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let module = fetchResult.managedObject() as? Module {
                if let modulesTree = context.object(with: self.objectID) as? ModulesTree {
                    modulesTree.currentModule = module
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModulesTreeNextModulesLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            guard let modulesTree = context.object(with: self.objectID) as? ModulesTree else {
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

    public class ModulesTreeNextVehicleLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let tank = fetchResult.managedObject() as? Vehicles {
                if let modulesTree = context.object(with: self.objectID) as? ModulesTree {
                    modulesTree.addToNext_tanks(tank)
                    self.coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
