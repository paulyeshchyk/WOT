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

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let tank = fetchResult.managedObject() as? Vehicles else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicles.self))
            return
        }
        guard let modulesTree = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? ModulesTree else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(ModulesTree.self))
            return
        }
        modulesTree.addToNext_tanks(tank)

        // MARK: stash
        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}

public class NextVehiclePredicateComposer: LinkedLocalAsPrimaryRuleBuilder {}
