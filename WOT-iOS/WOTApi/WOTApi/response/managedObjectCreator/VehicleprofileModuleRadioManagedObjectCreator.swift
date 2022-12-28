//
//  VehicleprofileModuleRadioManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleRadioManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.radio)] as? JSON
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        guard let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileRadio.self))
            return
        }
        guard let module = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? VehicleprofileModule else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
            return
        }
        vehicleProfileRadio.radio_id = mappedObjectIdentifier as? NSDecimalNumber
        module.vehicleRadio = vehicleProfileRadio
        dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}

public class VehicleprofileModuleRadioPredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}
