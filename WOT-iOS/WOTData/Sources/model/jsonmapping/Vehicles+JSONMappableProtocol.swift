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
    override public func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, linker: WOTLinkerProtocol?, mappingCoordinator: WOTMappingCoordinatorProtocol?, decoderAndMapper: WOTDecodeAndMappingProtocol) throws {
        //
        try self.decode(json: json)
        //
        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        // MARK: - DefaultProfile

        let defaultProfileJSON = json[#keyPath(Vehicles.default_profile)] as? JSON
        let builder = ForeignAsPrimaryRuleBuilder(requestPredicate: requestPredicate, foreignSelectKey: #keyPath(Vehicleprofile.vehicles), parentObjectIDList: nil)
        let mapper = Vehicles.DefaultProfileLinker.self
        linker?.linkItem(from: defaultProfileJSON, masterFetchResult: masterFetchResult, linkedClazz: Vehicleprofile.self, mapperClazz: mapper, lookupRuleBuilder: builder)

        // MARK: - ModulesTree

        let modulesTreeJSON = json[#keyPath(Vehicles.modules_tree)] as? JSON
        self.modulesTreeMapping(context: context, jSON: modulesTreeJSON, requestPredicate: requestPredicate, mappingCoordinator: mappingCoordinator, decoderAndMapper: decoderAndMapper)
    }
}

extension Vehicles {
    private func modulesTreeMapping(context: NSManagedObjectContext, jSON: JSON?, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol?, decoderAndMapper: WOTDecodeAndMappingProtocol) {
        if let set = self.modules_tree {
            self.removeFromModules_tree(set)
        }

        guard let moduleTreeJSON = jSON else {
            return
        }

        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehiclesFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        let modulesTreePredicate = RequestPredicate(parentObjectIDList: parentObjectIDList)
        modulesTreePredicate[.primary] = requestPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        moduleTreeJSON.keys.forEach { key in
            guard let moduleTreeJSON = moduleTreeJSON[key] as? JSON else { return }
            guard let module_id = moduleTreeJSON[#keyPath(ModulesTree.module_id)] as? NSNumber else { return }

            submoduleMapping(context: context, json: moduleTreeJSON, module_id: module_id, requestPredicate: modulesTreePredicate, masterFetchResult: vehiclesFetchResult, mappingCoordinator: mappingCoordinator, decoderAndMapper: decoderAndMapper)
        }
    }

    private func submoduleMapping(context: NSManagedObjectContext, json: JSON, module_id: NSNumber, requestPredicate: RequestPredicate, masterFetchResult: FetchResult, mappingCoordinator: WOTMappingCoordinatorProtocol?, decoderAndMapper: WOTDecodeAndMappingProtocol) {
        let submodulesPredicate = RequestPredicate(parentObjectIDList: requestPredicate.parentObjectIDList)
        submodulesPredicate[.primary] = ModulesTree.primaryKey(for: module_id, andType: .internal)
        submodulesPredicate[.secondary] = requestPredicate[.primary]

        let mapper = Vehicles.ModulesTreeLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: module_id)
        mappingCoordinator?.fetchLocalAndDecode(json: json, context: context, forClass: ModulesTree.self, requestPredicate: submodulesPredicate, mapper: mapper, callback: { _, _ in })
    }
}

extension Vehicles {
    public class ModulesTreeLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            let childObject = fetchResult.managedObject()

            guard let modulesTree = childObject as? ModulesTree else {
                let error = UnexpectedClassError(extected: ModulesTree.self, received: Swift.type(of: childObject))
                coreDataStore?.logEvent(EventError(error, details: nil), sender: self)
                return
            }
            guard let vehicles = masterFetchResult?.managedObject(inContext: context) as? Vehicles else {
                let received = masterFetchResult != nil ? Swift.type(of: masterFetchResult!) : nil
                let error = UnexpectedClassError(extected: Vehicles.self, received: received)
                coreDataStore?.logEvent(EventError(error, details: nil), sender: self)
                return
            }
            modulesTree.default_profile = vehicles.default_profile
            vehicles.addToModules_tree(modulesTree)
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class DefaultProfileLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            guard let defaultProfile = fetchResult.managedObject() as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
                return
            }
            guard let vehicles = masterFetchResult?.managedObject(inContext: context) as? Vehicles else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
                return
            }
            vehicles.default_profile = defaultProfile
            vehicles.modules_tree?.forEach {
                ($0 as? ModulesTree)?.default_profile = defaultProfile
            }
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class VehiclesPivotDataLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            coreDataStore?.stash(context: context, block: { error in
                completion(fetchResult, error)
            })
        }
    }

    public class VehiclesTreeViewLinker: BaseJSONAdapterLinker {
        // MARK: -

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            coreDataStore?.stash(context: context, block: { error in
                completion(fetchResult, error)
            })
        }
    }
}
