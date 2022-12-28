//
//  ModulesTree+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

extension ModulesTree {
    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let moduleTree = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try self.decode(decoderContainer: moduleTree)
        //

        let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - NextTanks

        let nextTanksJSONAdapter = ModulesTree.NextVehicleLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        if let nextTanks = moduleTree[#keyPath(ModulesTree.next_tanks)] as? [AnyObject] {
            for nextTank in nextTanks {
                // parents was not used for next portion of tanks
                let nextTanksPredicateComposer = ModulesTree.NextVehiclePredicateComposer(linkedClazz: Vehicles.self, linkedObjectID: nextTank)
                let nextTanksRequestParadigm = RequestParadigm(modelClass: Vehicles.self, requestPredicateComposer: nextTanksPredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
                do {
                    try inContext.requestManager?.fetchRemote(requestParadigm: nextTanksRequestParadigm, requestPredicateComposer: nextTanksPredicateComposer, managedObjectCreator: nextTanksJSONAdapter, listener: self)
                } catch {
                    inContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - NextModules

        let nextModuleJSONAdapter = ModulesTree.NextModulesLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        if let nextModules = moduleTree[#keyPath(ModulesTree.next_modules)] as? [AnyObject] {
            for nextModule in nextModules {
                let nextModulePredicateComposer = ModulesTree.NextModulesPredicateComposer(requestPredicate: map.predicate, linkedClazz: Module.self, linkedObjectID: nextModule, currentObjectID: self.objectID)
                let nextModuleRequestParadigm = RequestParadigm(modelClass: Module.self, requestPredicateComposer: nextModulePredicateComposer, keypathPrefix: nil, httpQueryItemName: "fields")
                do {
                    try inContext.requestManager?.fetchRemote(requestParadigm: nextModuleRequestParadigm, requestPredicateComposer: nextModulePredicateComposer, managedObjectCreator: nextModuleJSONAdapter, listener: self)
                } catch {
                    inContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - CurrentModule

        let moduleJSONAdapter = ModulesTree.CurrentModuleLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let modulePredicateComposer = ModulesTree.CurrentModulePredicateComposer(requestPredicate: map.predicate, linkedClazz: Module.self, linkedObjectID: module_id, currentObjectID: self.objectID)
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

extension ModulesTree {
    private class CurrentModulePredicateComposer: LinkedRemoteAsPrimaryRuleBuilder {}

    private class CurrentModuleLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
            guard let module = fetchResult.managedObject() as? Module else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Module.self))
                return
            }
            guard let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? ModulesTree else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(ModulesTree.self))
                return
            }
            modulesTree.currentModule = module
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }
}

extension ModulesTree {
    private class NextModulesPredicateComposer: MasterAsPrimaryLinkedAsSecondaryRuleBuilder {}

    private class NextModulesLinker: ManagedObjectCreator {
        private enum NextModulesLinkerError: Error, CustomStringConvertible {
            case wrongParentClass
            case wrongChildClass
            var description: String {
                switch self {
                case .wrongChildClass: return "[\(String(describing: self))]: wrong child class"
                case .wrongParentClass: return "[\(String(describing: self))]: wrong parent class"
                }
            }
        }

        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
            guard let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? ModulesTree else {
                completion(fetchResult, NextModulesLinkerError.wrongParentClass)
                return
            }
            guard let nextModule = fetchResult.managedObject() as? Module else {
                completion(fetchResult, NextModulesLinkerError.wrongChildClass)
                return
            }
            modulesTree.addToNext_modules(nextModule)
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }
}

extension ModulesTree {
    private class NextVehiclePredicateComposer: LinkedLocalAsPrimaryRuleBuilder {}

    private class NextVehicleLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
            if let tank = fetchResult.managedObject() as? Vehicles {
                if let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? ModulesTree {
                    modulesTree.addToNext_tanks(tank)
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
