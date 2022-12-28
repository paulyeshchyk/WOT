//
//  ModulesTreeNextModulesManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModulesTreeNextModulesManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? ModulesTree else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(ModulesTree.self))
            return
        }
        guard let nextModule = fetchResult.managedObject() as? Module else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Module.self))
            return
        }
        modulesTree.addToNext_modules(nextModule)

        // MARK: stash
        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}

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

public class NextModulesPredicateComposer: MasterAsPrimaryLinkedAsSecondaryRuleBuilder {}
