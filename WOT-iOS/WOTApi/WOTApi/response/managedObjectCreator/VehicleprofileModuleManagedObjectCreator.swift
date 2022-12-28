//
//  VehicleprofileModuleManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let modules = fetchResult.managedObject() as? VehicleprofileModule else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
            return
        }
        guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
            return
        }
        vehicleProfile.modules = modules
        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
