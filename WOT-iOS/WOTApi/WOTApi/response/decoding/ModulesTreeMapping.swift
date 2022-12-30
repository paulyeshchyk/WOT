//
//  ModulesTree+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension ModulesTree {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let moduleTreeJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: moduleTreeJSON)
        //

        let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - NextTanks

        let nextTanksManagedObjectCreator = ModulesTreeNextVehicleManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        if let nextTanks = moduleTreeJSON[#keyPath(ModulesTree.next_tanks)] as? [AnyObject] {
            for nextTank in nextTanks {
                // parents was not used for next portion of tanks
                let nextTanksPredicateComposer = NextVehiclePredicateComposer(linkedClazz: Vehicles.self, linkedObjectID: nextTank)
                let nextTanksRequestParadigm = RequestParadigm(modelClass: Vehicles.self, requestPredicateComposer: nextTanksPredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
                do {
                    try appContext.requestManager?.fetchRemote(requestParadigm: nextTanksRequestParadigm, managedObjectCreator: nextTanksManagedObjectCreator, listener: self)
                } catch {
                    appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - NextModules

        let nextModuleManagedObjectCreator = ModulesTreeNextModulesManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        if let nextModules = moduleTreeJSON[#keyPath(ModulesTree.next_modules)] as? [AnyObject] {
            for nextModule in nextModules {
                let nextModulePredicateComposer = NextModulesPredicateComposer(requestPredicate: map.predicate, linkedClazz: Module.self, linkedObjectID: nextModule, currentObjectID: objectID)
                let nextModuleRequestParadigm = RequestParadigm(modelClass: Module.self, requestPredicateComposer: nextModulePredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
                do {
                    try appContext.requestManager?.fetchRemote(requestParadigm: nextModuleRequestParadigm, managedObjectCreator: nextModuleManagedObjectCreator, listener: self)
                } catch {
                    appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - CurrentModule

        let moduleJSONAdapter = ModulesTreeCurrentModuleManagedObjectCreator(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let modulePredicateComposer = CurrentModulePredicateComposer(requestPredicate: map.predicate, linkedClazz: Module.self, linkedObjectID: module_id, currentObjectID: objectID)
        let moduleRequestParadigm = RequestParadigm(modelClass: Module.self, requestPredicateComposer: modulePredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
        try appContext.requestManager?.fetchRemote(requestParadigm: moduleRequestParadigm, managedObjectCreator: moduleJSONAdapter, listener: self)
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
