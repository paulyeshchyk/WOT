//
//  ModulesTree+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension ModulesTree {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let moduleTreeJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: moduleTreeJSON)
        //

        let modulesTreeFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        // MARK: - NextTanks

        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        if let nextTanks = moduleTreeJSON[nextTanksKeypath] as? [AnyObject] {
            let anchor = ManagedObjectLinkerAnchor(identifier: nil, keypath: nextTanksKeypath)
            let linker = ManagedObjectLinker(modelClass: Vehicles.self, masterFetchResult: modulesTreeFetchResult, anchor: anchor)
            let extractor = ModulesTreeNextVehicleManagedObjectExtractor()
            for nextTank in nextTanks {
                // parents was not used for next portion of tanks
                let theLink = Joint(modelClass: Vehicles.self, theID: nextTank, thePredicate: nil)
                let composer = LinkedLocalAsPrimaryRuleBuilder(drivenJoint: theLink)
                do {
                    let composition = try composer.buildRequestPredicateComposition()
                    let requestParadigm = RequestParadigm(modelClass: Vehicles.self, requestPredicateComposition: composition, keypathPrefix: nil, httpQueryItemName: "fields")
                    try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
                } catch {
                    appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - NextModules

        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        if let nextModules = moduleTreeJSON[nextModulesKeypath] as? [AnyObject] {
            let anchor = ManagedObjectLinkerAnchor(identifier: nil, keypath: nextModulesKeypath)
            let extractor = ModulesTreeNextModulesManagedObjectCreator()
            let nextModuleManagedObjectCreator = ManagedObjectLinker(modelClass: ModulesTree.self, masterFetchResult: modulesTreeFetchResult, anchor: anchor)
            for nextModuleID in nextModules {
                let modelClass = Module.self
                let theLink = Joint(modelClass: modelClass, theID: nextModuleID, thePredicate: map.predicate)
                let composer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(drivenJoint: theLink, hostObjectID: objectID)
                do {
                    let composition = try composer.buildRequestPredicateComposition()
                    let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: nil, httpQueryItemName: "fields")
                    try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, managedObjectLinker: nextModuleManagedObjectCreator, managedObjectExtractor: extractor, listener: self)
                } catch {
                    appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - CurrentModule

        let keypath = #keyPath(ModulesTree.currentModule)
        let modelClass = Module.self
        let currentModuleAnchor = ManagedObjectLinkerAnchor(identifier: nil, keypath: keypath)
        let extractor = ModulesTreeCurrentModuleManagedObjectCreator()
        let moduleJSONAdapter = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: modulesTreeFetchResult, anchor: currentModuleAnchor)
        let theLink = Joint(modelClass: Module.self, theID: module_id, thePredicate: map.predicate)
        let composer = LinkedRemoteAsPrimaryRuleBuilder(drivenJoint: theLink, hostObjectID: objectID)
        let composition = try composer.buildRequestPredicateComposition()
        let moduleRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposition: composition, keypathPrefix: nil, httpQueryItemName: "fields")
        try appContext.requestManager?.fetchRemote(requestParadigm: moduleRequestParadigm, managedObjectLinker: moduleJSONAdapter, managedObjectExtractor: extractor, listener: self)
    }
}

// MARK: - ModulesTree + RequestManagerListenerProtocol

extension ModulesTree: RequestManagerListenerProtocol {
    public func requestManager(_: RequestManagerProtocol, didParseDataForRequest _: RequestProtocol, error _: Error?) {
        //
    }

    public func requestManager(_: RequestManagerProtocol, didStartRequest _: RequestProtocol) {
        //
    }

    public func requestManager(_: RequestManagerProtocol, didCancelRequest _: RequestProtocol, reason _: RequestCancelReasonProtocol) {
        //
    }
}
