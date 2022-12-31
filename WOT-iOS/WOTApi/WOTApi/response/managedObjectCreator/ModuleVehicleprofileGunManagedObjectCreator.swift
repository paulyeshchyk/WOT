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

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileGun.self))
            return
        }
        guard let module = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? Module else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Module.self))
            return
        }
        vehicleProfileGun.gun_id = mappedObjectIdentifier as? NSDecimalNumber
        module.gun = vehicleProfileGun

        // MARK: stash

        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
