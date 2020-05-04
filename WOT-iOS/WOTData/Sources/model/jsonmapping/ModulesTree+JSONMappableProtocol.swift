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
        var parents = pkCase.plainParents
        parents.append(self)

        // MARK: - CurrentModule
        let currentModuleHelper = ModulesTree.CurrentModuleJSONAdapterHelper(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        let currentModulePK = PKCase(parentObjects: parents)
        currentModulePK[.primary] = Module.primaryKey(for: self.module_id as AnyObject, andType: .external)
        mappingCoordinator?.fetchRemote(context: context, byModelClass: Module.self, pkCase: currentModulePK, keypathPrefix: nil, instanceHelper: currentModuleHelper)

        // MARK: - NextModules
        let nextModulesHelper = ModulesTree.NextModulesJSONAdapterHelper(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        let nextModules = json[#keyPath(ModulesTree.next_modules)] as? [AnyObject]
        nextModules?.forEach {
            let modulePK = PKCase(parentObjects: parents)
            modulePK[.primary] = pkCase[.primary]
            modulePK[.secondary] = Module.primaryKey(for: $0, andType: .external)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: Module.self, pkCase: modulePK, keypathPrefix: nil, instanceHelper: nextModulesHelper)
        }

        #warning("Next Tanks")
//        // MARK: - NextTanks
//        let nextTanksHelper = ModulesTree.NextTanksJSONAdapterHelper(objectID: self.objectID, identifier: nil, persistentStore: persistentStore)
//        let nextTanks = jSON[#keyPath(ModulesTree.next_tanks)]
//        (nextTanks as? [AnyObject])?.forEach {
//            // parents was not used for next portion of tanks
//            let nextTanksPK = PKCase(parentObjects: nil)
//            nextTanksPK[.primary] = Vehicles.primaryKey(for: $0, andType: .internal)
//            persistentStore?.fetchRemote(context: context, byModelClass: Vehicles.self, pkCase: nextTanksPK, keypathPrefix: nil, instanceHelper: nextTanksHelper)
//        }
    }
}

extension ModulesTree {
    public class DefaultProfileJSONAdapterHelper: JSONAdapterInstanceHelper {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let modulesTree = fetchResult.managedObject() as? ModulesTree {
                if let vehicles = context.object(with: objectID) as? Vehicles {
                    modulesTree.default_profile = vehicles.default_profile
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class CurrentModuleJSONAdapterHelper: JSONAdapterInstanceHelper {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let module = fetchResult.managedObject() as? Module {
                if let modulesTree = context.object(with: objectID) as? ModulesTree {
                    modulesTree.currentModule = module
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class NextModulesJSONAdapterHelper: JSONAdapterInstanceHelper {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let nextModule = fetchResult.managedObject() as? Module {
                if let modulesTree = context.object(with: objectID) as? ModulesTree {
                    modulesTree.addToNext_modules(nextModule)
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class NextTanksJSONAdapterHelper: JSONAdapterInstanceHelper {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let tank = fetchResult.managedObject() as? Vehicles {
                if let modulesTree = context.object(with: objectID) as? ModulesTree {
                    modulesTree.addToNext_tanks(tank)
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }
}
