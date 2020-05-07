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

        let vehiclesFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        let defaultProfileHelper: JSONAdapterLinkerProtocol? = nil
        self.defaultProfileMapping(context: context, jSON: json[#keyPath(Vehicles.default_profile)] as? JSON, pkCase: pkCase, linker: defaultProfileHelper, mappingCoordinator: mappingCoordinator)

        let modulesTreeHelper: JSONAdapterLinkerProtocol? = Vehicles.VehiclesModulesTreeLinker(masterFetchResult: vehiclesFetchResult, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
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

        let vehiclesFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        var parentObjectIDList = pkCase.parentObjectIDList
        parentObjectIDList.append(self.objectID)
        let modulesTreeCase = PKCase(parentObjectIDList: parentObjectIDList)
        modulesTreeCase[.primary] = pkCase[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))
        moduleTreeJSON.keys.forEach { key in
            guard let moduleTreeJSON = moduleTreeJSON[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber else { return }

            let modulePK = ModulesTree.primaryKey(for: module_id, andType: .internal)
            let submodulesCase = PKCase(parentObjectIDList: modulesTreeCase.parentObjectIDList)
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

                let moduleTreeHelper: JSONAdapterLinkerProtocol? = Vehicles.VehiclesModulesTreeLinker(masterFetchResult: vehiclesFetchResult, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
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
    public class VehiclesModulesTreeLinker: BaseJSONAdapterLinker {
        // MARK: -
        override public var primaryKeyType: PrimaryKeyType { return .external }
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

    public class VehiclesPivotDataLinker: BaseJSONAdapterLinker {
        // MARK: -
        override public var primaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            coreDataStore?.stash(context: context, block: { error in
                completion(fetchResult, error)
            })
        }
    }
}
