//
//  VehicleprofileArmorListTurretManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileArmorListTurretManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let armor = fetchResult.managedObject() as? VehicleprofileArmor else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmor.self))
            return
        }
        guard let armorList = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileArmorList else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmorList.self))
            return
        }
        armorList.turret = armor
        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
