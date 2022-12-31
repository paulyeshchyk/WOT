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

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let armor = fetchResult.managedObject() as? VehicleprofileArmor else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmor.self))
            return
        }
        guard let armorList = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? VehicleprofileArmorList else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmorList.self))
            return
        }
        armorList.turret = armor

        // MARK: stash

        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
