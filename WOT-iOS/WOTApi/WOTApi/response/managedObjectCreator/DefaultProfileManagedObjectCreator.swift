//
//  DefaultProfileManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class DefaultProfileManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let defaultProfile = fetchResult.managedObject() as? Vehicleprofile else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
            return
        }
        guard let vehicles = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? Vehicles else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicles.self))
            return
        }
        vehicles.default_profile = defaultProfile
        vehicles.modules_tree?.compactMap { $0 as? ModulesTree }.forEach {
            $0.default_profile = defaultProfile
        }

        // MARK: stash

        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
