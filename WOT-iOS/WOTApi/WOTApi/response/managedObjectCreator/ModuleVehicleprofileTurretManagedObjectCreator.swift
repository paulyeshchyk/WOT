//
//  ModuleVehicleprofileTurretManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModuleVehicleprofileTurretManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.turret)] as? JSON
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
            if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                vehicleProfileTurret.turret_id = self.mappedObjectIdentifier as? NSDecimalNumber
                module.turret = vehicleProfileTurret
                dataStore?.stash(objectContext: managedObjectContext) { error in
                    completion(fetchResult, error)
                }
            }
        }
    }
}
