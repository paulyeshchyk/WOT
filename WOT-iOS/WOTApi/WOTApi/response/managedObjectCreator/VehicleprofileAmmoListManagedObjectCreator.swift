//
//  VehicleprofileAmmoListManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileAmmoListManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let ammoList = fetchResult.managedObject() as? VehicleprofileAmmoList else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoList.self))
            return
        }
        guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoList.self))
            return
        }
        vehicleProfile.ammo = ammoList

        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
