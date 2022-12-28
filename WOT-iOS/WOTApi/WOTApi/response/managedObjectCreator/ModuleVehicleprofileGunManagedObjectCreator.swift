//
//  ModuleVehicleprofileGunManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModuleVehicleprofileGunManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.gun)] as? JSON
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
            if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                vehicleProfileGun.gun_id = self.mappedObjectIdentifier as? NSDecimalNumber
                module.gun = vehicleProfileGun
                dataStore?.stash(objectContext: managedObjectContext) { error in
                    completion(fetchResult, error)
                }
            }
        }
    }
}
