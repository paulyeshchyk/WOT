//
//  ModulesTree+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension ModulesTree {
    // MARK: - JSONMappableProtocol

    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let moduleTree = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try self.decode(decoderContainer: moduleTree)
        //

        let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - NextTanks

        let nextTanksJSONAdapter = ModulesTreeNextVehicleManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        if let nextTanks = moduleTree[#keyPath(ModulesTree.next_tanks)] as? [AnyObject] {
            for nextTank in nextTanks {
                // parents was not used for next portion of tanks
                let nextTanksPredicateComposer = NextVehiclePredicateComposer(linkedClazz: Vehicles.self, linkedObjectID: nextTank)
                let nextTanksRequestParadigm = RequestParadigm(modelClass: Vehicles.self, requestPredicateComposer: nextTanksPredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
                do {
                    try inContext.requestManager?.fetchRemote(requestParadigm: nextTanksRequestParadigm, requestPredicateComposer: nextTanksPredicateComposer, managedObjectCreator: nextTanksJSONAdapter, listener: self)
                } catch {
                    inContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - NextModules

        let nextModuleJSONAdapter = ModulesTreeNextModulesManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        if let nextModules = moduleTree[#keyPath(ModulesTree.next_modules)] as? [AnyObject] {
            for nextModule in nextModules {
                let nextModulePredicateComposer = NextModulesPredicateComposer(requestPredicate: map.predicate, linkedClazz: Module.self, linkedObjectID: nextModule, currentObjectID: self.objectID)
                let nextModuleRequestParadigm = RequestParadigm(modelClass: Module.self, requestPredicateComposer: nextModulePredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
                do {
                    try inContext.requestManager?.fetchRemote(requestParadigm: nextModuleRequestParadigm, requestPredicateComposer: nextModulePredicateComposer, managedObjectCreator: nextModuleJSONAdapter, listener: self)
                } catch {
                    inContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - CurrentModule

        let moduleJSONAdapter = ModulesTreeCurrentModuleManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let modulePredicateComposer = CurrentModulePredicateComposer(requestPredicate: map.predicate, linkedClazz: Module.self, linkedObjectID: module_id, currentObjectID: self.objectID)
        let moduleRequestParadigm = RequestParadigm(modelClass: Module.self, requestPredicateComposer: modulePredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
        try inContext.requestManager?.fetchRemote(requestParadigm: moduleRequestParadigm, requestPredicateComposer: modulePredicateComposer, managedObjectCreator: moduleJSONAdapter, listener: self)
    }
}

extension ModulesTree: RequestManagerListenerProtocol {
    public var MD5: String { uuid.MD5 }
    public var uuid: UUID { UUID() }

    public func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType) {
        //
    }

    public func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol) {
        //
    }
}
