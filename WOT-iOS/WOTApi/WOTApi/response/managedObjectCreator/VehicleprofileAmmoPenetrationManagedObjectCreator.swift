//
//  VehicleprofileAmmoPenetrationManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileAmmoPenetrationManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        guard let penetration = fetchResult.managedObject() as? VehicleprofileAmmoPenetration else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoPenetration.self))
            return
        }
        guard let ammo = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? VehicleprofileAmmo else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmo.self))
            return
        }

        ammo.penetration = penetration
        dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
