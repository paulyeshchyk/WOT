//
//  VehicleprofileModuleSuspensionPredicateComposer.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleSuspensionManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.suspension)] as? JSON
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileSuspension.self))
            return
        }
        guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileModule else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
            return
        }
        vehicleProfileSuspension.suspension_id = mappedObjectIdentifier as? NSDecimalNumber
        module.vehicleChassis = vehicleProfileSuspension
        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}

public class VehicleprofileModuleSuspensionPredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}
