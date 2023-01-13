//
//  ModulesTree+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension ModulesTree {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        //
        let moduleTreeJSON = try map.data(ofType: JSON.self)
        try decode(decoderContainer: moduleTreeJSON)
        //

        let modulesTreeFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        // MARK: - NextTanks

        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        if let nextTanks = moduleTreeJSON?[nextTanksKeypath] as? [AnyObject] {
            let socket = JointSocket(identifier: nil, keypath: nextTanksKeypath)
            let linker = ManagedObjectLinker(modelClass: Vehicles.self, masterFetchResult: modulesTreeFetchResult, socket: socket)
            let extractor = NextVehicleExtractor()
            for nextTank in nextTanks {
                // parents was not used for next portion of tanks
                let pin = JointPin(modelClass: Vehicles.self, identifier: nextTank, contextPredicate: nil)
                let composer = LinkedLocalAsPrimaryRuleBuilder(pin: pin)
                do {
                    let modelClass = Vehicles.self
                    let composition = try composer.buildRequestPredicateComposition()

                    try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: self)
                } catch {
                    appContext?.logInspector?.log(.error(error), sender: self)
                }
            }
        }

        // MARK: - NextModules

        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        if let nextModules = moduleTreeJSON?[nextModulesKeypath] as? [AnyObject] {
            let socket = JointSocket(identifier: nil, keypath: nextModulesKeypath)
            let extractor = NextModuleExtractor()
            let nextModuleManagedObjectCreator = ManagedObjectLinker(modelClass: ModulesTree.self, masterFetchResult: modulesTreeFetchResult, socket: socket)
            for nextModuleID in nextModules {
                let modelClass = Module.self
                let pin = JointPin(modelClass: modelClass, identifier: nextModuleID, contextPredicate: map.contextPredicate)
                let composer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(pin: pin, hostObjectID: objectID)
                do {
                    let composition = try composer.buildRequestPredicateComposition()

                    try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: nextModuleManagedObjectCreator, managedObjectExtractor: extractor, listener: self)
                } catch {
                    appContext?.logInspector?.log(.error(error), sender: self)
                }
            }
        }

        // MARK: - CurrentModule

        let keypath = #keyPath(ModulesTree.currentModule)
        let modelClass = Module.self
        let currentModuleAnchor = JointSocket(identifier: nil, keypath: keypath)
        let extractor = CurrentModuleExtractor()
        let moduleJSONAdapter = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: modulesTreeFetchResult, socket: currentModuleAnchor)
        let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: map.contextPredicate)
        let composer = LinkedRemoteAsPrimaryRuleBuilder(pin: pin, hostObjectID: objectID)
        let composition = try composer.buildRequestPredicateComposition()

        try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: moduleJSONAdapter, managedObjectExtractor: extractor, listener: self)
    }
}

extension ModulesTree {

    private class NextVehicleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class NextModuleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class CurrentModuleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
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
