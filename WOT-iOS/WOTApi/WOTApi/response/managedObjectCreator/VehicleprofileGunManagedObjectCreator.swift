//
//  VehicleprofileGunManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileGunManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let gun = fetchResult.managedObject() as? VehicleprofileGun else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileGun.self))
            return
        }
        guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
            return
        }
        vehicleProfile.gun = gun

        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
