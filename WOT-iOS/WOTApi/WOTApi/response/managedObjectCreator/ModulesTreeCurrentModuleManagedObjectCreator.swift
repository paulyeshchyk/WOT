//
//  ModulesTreeCurrentModuleManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModulesTreeCurrentModuleManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

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

public class CurrentModulePredicateComposer: LinkedRemoteAsPrimaryRuleBuilder {}
