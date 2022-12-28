//
//  VehicleprofileModuleTurretManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleTurretManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.turret)] as? JSON
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileTurret.self))
            return
        }
        guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileModule else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileTurret.self))
            return
        }
        vehicleProfileTurret.turret_id = mappedObjectIdentifier as? NSDecimalNumber
        module.vehicleTurret = vehicleProfileTurret
        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}

public class VehicleprofileModuleTurretPredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}
