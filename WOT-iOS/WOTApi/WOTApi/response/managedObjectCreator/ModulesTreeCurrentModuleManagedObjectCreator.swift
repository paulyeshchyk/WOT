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

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let module = fetchResult.managedObject() as? Module else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Module.self))
            return
        }
        guard let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? ModulesTree else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(ModulesTree.self))
            return
        }
        modulesTree.currentModule = module

        // MARK: stash

        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}

public class CurrentModulePredicateComposer: LinkedRemoteAsPrimaryRuleBuilder {}
