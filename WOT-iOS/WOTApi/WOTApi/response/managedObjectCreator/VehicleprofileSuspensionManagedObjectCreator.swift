//
//  VehicleprofileSuspensionManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileSuspensionManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        guard let suspension = fetchResult.managedObject() as? VehicleprofileSuspension else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileSuspension.self))
            return
        }
        guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? Vehicleprofile else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
            return
        }
        vehicleProfile.suspension = suspension

        dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
