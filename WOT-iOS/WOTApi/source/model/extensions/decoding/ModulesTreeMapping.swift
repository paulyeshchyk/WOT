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

        let masterFetchResult = FetchResult(objectID: objectID, inContext: managedObjectContextContainer.managedObjectContext, predicate: nil, fetchStatus: .recovered)

        // MARK: - NextTanks

        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        if let nextTanks = moduleTreeJSON[nextTanksKeypath] as? [AnyObject] {
            let anchor = ManagedObjectLinkerAnchor(identifier: nil, keypath: nextTanksKeypath)
            let nextTanksManagedObjectCreator = ModulesTreeNextVehicleManagedObjectCreator(modelClass: Vehicles.self, masterFetchResult: masterFetchResult, anchor: anchor)
            for nextTank in nextTanks {
                // parents was not used for next portion of tanks
                let theLink = Joint(theClass: Vehicles.self, theID: nextTank, thePredicate: nil)
                let nextTanksPredicateComposer = LinkedLocalAsPrimaryRuleBuilder(drivenJoint: theLink)
                let requestParadigm = RequestParadigm(modelClass: Vehicles.self, requestPredicateComposer: nextTanksPredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
                do {
                    try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, linker: nextTanksManagedObjectCreator, listener: self)
                } catch {
                    appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - NextModules

        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        if let nextModules = moduleTreeJSON[nextModulesKeypath] as? [AnyObject] {
            let anchor = ManagedObjectLinkerAnchor(identifier: nil, keypath: nextModulesKeypath)
            let nextModuleManagedObjectCreator = ModulesTreeNextModulesManagedObjectCreator(modelClass: ModulesTree.self, masterFetchResult: masterFetchResult, anchor: anchor)
            for nextModuleID in nextModules {
                let modelClass = Module.self
                let theLink = Joint(theClass: modelClass, theID: nextModuleID, thePredicate: map.predicate)
                let nextModulePredicateComposer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(drivenJoint: theLink, hostObjectID: objectID)
                let requestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: nextModulePredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
                do {
                    try appContext.requestManager?.fetchRemote(requestParadigm: requestParadigm, linker: nextModuleManagedObjectCreator, listener: self)
                } catch {
                    appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - CurrentModule

        let keypath = #keyPath(ModulesTree.currentModule)
        let modelClass = Module.self
        let currentModuleAnchor = ManagedObjectLinkerAnchor(identifier: nil, keypath: keypath)
        let moduleJSONAdapter = ModulesTreeCurrentModuleManagedObjectCreator(modelClass: modelClass, masterFetchResult: masterFetchResult, anchor: currentModuleAnchor)
        let theLink = Joint(theClass: Module.self, theID: module_id, thePredicate: map.predicate)
        let modulePredicateComposer = LinkedRemoteAsPrimaryRuleBuilder(drivenJoint: theLink, hostObjectID: objectID)
        let moduleRequestParadigm = RequestParadigm(modelClass: modelClass, requestPredicateComposer: modulePredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
        try appContext.requestManager?.fetchRemote(requestParadigm: moduleRequestParadigm, linker: moduleJSONAdapter, listener: self)
    }
}

extension ModulesTree: RequestManagerListenerProtocol {
    public var MD5: String { uuid.MD5 }
    public var uuid: UUID { UUID() }

    public func requestManager(_: RequestManagerProtocol, didParseDataForRequest _: RequestProtocol, completionResultType _: WOTRequestManagerCompletionResultType) {
        //
    }

    public func requestManager(_: RequestManagerProtocol, didStartRequest _: RequestProtocol) {
        //
    }

    public func requestManager(_: RequestManagerProtocol, didCancelRequest _: RequestProtocol, reason _: RequestCancelReasonProtocol) {
        //
    }
}
