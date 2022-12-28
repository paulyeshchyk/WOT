//
//  VehicleprofileTurretManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileTurretManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let turret = fetchResult.managedObject() as? VehicleprofileTurret else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileTurret.self))
            return
        }
        guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? Vehicleprofile else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
            return
        }
        vehicleProfile.turret = turret

        // MARK: stash
        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
