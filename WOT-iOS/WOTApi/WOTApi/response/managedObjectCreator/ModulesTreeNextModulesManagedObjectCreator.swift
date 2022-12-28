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
