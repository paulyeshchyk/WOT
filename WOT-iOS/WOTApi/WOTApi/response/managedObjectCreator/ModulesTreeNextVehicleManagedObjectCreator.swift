//
//  ModulesTreeNextVehicleManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModulesTreeNextVehicleManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

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

public class NextVehiclePredicateComposer: LinkedLocalAsPrimaryRuleBuilder {}
