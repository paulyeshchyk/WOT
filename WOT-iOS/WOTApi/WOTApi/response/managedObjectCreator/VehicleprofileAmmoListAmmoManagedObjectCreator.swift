//
//  VehicleprofileAmmoListAmmoManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileAmmoListAmmoManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let ammo = fetchResult.managedObject() as? VehicleprofileAmmo else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmo.self))
            return
        }
        guard let ammoList = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileAmmoList else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoList.self))
            return
        }
        ammoList.addToVehicleprofileAmmo(ammo)
        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
