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
        let defaultProfileHelper: JSONAdapterLinkerProtocol? = nil
        self.defaultProfileMapping(context: context, jSON: json[#keyPath(Vehicles.default_profile)] as? JSON, pkCase: pkCase, linker: defaultProfileHelper, mappingCoordinator: mappingCoordinator)

        let modulesTreeHelper: JSONAdapterLinkerProtocol? = Vehicles.VehiclesModulesTreeLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        self.modulesTreeMapping(context: context, jSON: json[#keyPath(Vehicles.modules_tree)] as? JSON, pkCase: pkCase, linker: modulesTreeHelper, mappingCoordinator: mappingCoordinator)
    }
}

extension Vehicles {
    private func defaultProfileMapping(context: NSManagedObjectContext, jSON: JSON?, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        guard let itemJSON = jSON else { return }

        let vehicleProfileCase = PKCase()
        vehicleProfileCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))
        mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: Vehicleprofile.self, pkCase: vehicleProfileCase, linker: linker, callback: { fetchResult, error in

            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                return
            }

            let context = fetchResult.context
            if let defaultProfile = fetchResult.managedObject() as? Vehicleprofile {
                //
                #warning("not used linker")
                self.default_profile = defaultProfile
                self.modules_tree?.forEach { element in
                    (element as? ModulesTree)?.default_profile = defaultProfile
                }
                mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                    if let error = error {
                        mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    }
                }
            }
        })
    }

    private func modulesTreeMapping(context: NSManagedObjectContext, jSON: JSON?, pkCase: PKCase, linker: JSONAdapterLinkerProtocol?, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            return
        }

        var parents = pkCase.plainParents
        parents.append(self)
        let modulesTreeCase = PKCase(parentObjects: parents)
        modulesTreeCase[.primary] = pkCase[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))
        moduleTreeJSON.keys.forEach { key in
            guard let moduleTreeJSON = moduleTreeJSON[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber else { return }

            let modulePK = ModulesTree.primaryKey(for: module_id, andType: .internal)
            let submodulesCase = PKCase(parentObjects: modulesTreeCase.plainParents)
            submodulesCase[.primary] = modulePK
            submodulesCase[.secondary] = modulesTreeCase[.primary]

            mappingCoordinator?.fetchLocal(context: context, byModelClass: ModulesTree.self, pkCase: submodulesCase) { fetchResult, error in

                if let error = error {
                    mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }

                guard let module_tree = fetchResult.managedObject() as? ModulesTree else {
                    return
                }

                #warning("not used linker")
                self.addToModules_tree(module_tree)

                let moduleTreeHelper: JSONAdapterLinkerProtocol? = Vehicles.VehiclesModulesTreeLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.decodingAndMapping(json: moduleTreeJSON, fetchResult: fetchResult, pkCase: modulesTreeCase, linker: moduleTreeHelper, completion: { _, error in
                    if let error = error {
                        mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    }
                })
            }
        }
    }
}

extension Vehicles {
    public class VehiclesModulesTreeLinker: JSONAdapterLinkerProtocol {
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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let modulesTree = fetchResult.managedObject() as? ModulesTree {
                if let vehicles = context.object(with: objectID) as? Vehicles {
                    modulesTree.default_profile = vehicles.default_profile
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehiclesPivotDataLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .internal
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            coreDataStore?.stash(context: context, block: { error in
                completion(fetchResult, error)
            })
        }
    }
}
