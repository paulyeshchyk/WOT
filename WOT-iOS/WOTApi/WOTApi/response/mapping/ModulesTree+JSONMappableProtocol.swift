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

//        // MARK: - NextTanks
//
//        let nextTanksJSONAdapter = ModulesTree.NextVehicleLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
//        if let nextTanks = moduleTree[#keyPath(ModulesTree.next_tanks)] as? [AnyObject] {
//            for nextTank in nextTanks {
//                // parents was not used for next portion of tanks
//                let nextTanksRequestPredicateComposer = LinkedLocalAsPrimaryRuleBuilder(linkedClazz: Vehicles.self, linkedObjectID: nextTank)
//                let nextTanksRequestParadigm = MappingParadigm(clazz: Vehicles.self, adapter: nextTanksJSONAdapter, requestPredicateComposer: nextTanksRequestPredicateComposer, keypathPrefix: nil)
//                do {
//                    try inContext.requestManager?.fetchRemote(paradigm: nextTanksRequestParadigm)
//                } catch {
//                    inContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
//                }
//            }
//        }

        // MARK: - NextModules

        let nextModuleJSONAdapter = ModulesTree.NextModulesLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        if let nextModules = moduleTree[#keyPath(ModulesTree.next_modules)] as? [AnyObject] {
            for nextModule in nextModules {
                let nextModuleRequestPredicateComposer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(requestPredicate: map.predicate, linkedClazz: Module.self, linkedObjectID: nextModule, currentObjectID: self.objectID)
                let nextModuleRequestParadigm = MappingParadigm(clazz: Module.self, adapter: nextModuleJSONAdapter, requestPredicateComposer: nextModuleRequestPredicateComposer, keypathPrefix: nil)
                do {
                    try inContext.requestManager?.fetchRemote(mappingParadigm: nextModuleRequestParadigm, listener: self)
                } catch {
                    inContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                }
            }
        }

        // MARK: - CurrentModule

        let moduleJSONAdapter = ModulesTree.CurrentModuleLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil)
        let moduleRequestPredicateComposer = LinkedRemoteAsPrimaryRuleBuilder(requestPredicate: map.predicate, linkedClazz: Module.self, linkedObjectID: module_id, currentObjectID: self.objectID)
        let moduleRequestParadigm = MappingParadigm(clazz: Module.self, adapter: moduleJSONAdapter, requestPredicateComposer: moduleRequestPredicateComposer, keypathPrefix: nil)
        try inContext.requestManager?.fetchRemote(mappingParadigm: moduleRequestParadigm, listener: self)
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
    public class CurrentModuleLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
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

    public class NextModulesLinker: BaseJSONAdapterLinker {
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
            let managedObjectContext = fetchResult.objectContext
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

    public class NextVehicleLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
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
