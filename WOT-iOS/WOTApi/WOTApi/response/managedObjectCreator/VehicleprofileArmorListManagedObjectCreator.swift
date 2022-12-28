//
//  VehicleprofileArmorListManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileArmorListManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let armorList = fetchResult.managedObject() as? VehicleprofileArmorList else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmor.self))
            return
        }
        guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmor.self))
            return
        }
        vehicleProfile.armor = armorList

        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
