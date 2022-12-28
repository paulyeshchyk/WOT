//
//  VehicleprofileArmorListHullManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileArmorListHullManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        if let armor = fetchResult.managedObject() as? VehicleprofileArmor {
            if let armorList = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileArmorList {
                armorList.hull = armor

                dataStore?.stash(objectContext: managedObjectContext) { error in
                    completion(fetchResult, error)
                }
            }
        }
    }
}
