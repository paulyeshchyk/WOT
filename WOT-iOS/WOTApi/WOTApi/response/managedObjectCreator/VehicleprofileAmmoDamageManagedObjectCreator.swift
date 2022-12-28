//
//  VehicleprofileAmmoDamageManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileAmmoDamageManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let objectContext = fetchResult.managedObjectContext
        guard let damage = fetchResult.managedObject() as? VehicleprofileAmmoDamage else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoDamage.self))
            return
        }
        guard let ammo = masterFetchResult?.managedObject(inManagedObjectContext: objectContext) as? VehicleprofileAmmo else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmo.self))
            return
        }
        ammo.damage = damage

        dataStore?.stash(objectContext: objectContext) { error in
            completion(fetchResult, error)
        }
    }
}
