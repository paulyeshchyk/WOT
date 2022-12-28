//
//  ModuleVehicleprofileRadioManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModuleVehicleprofileRadioManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.radio)] as? JSON
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
            if let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Module {
                vehicleProfileRadio.radio_id = self.mappedObjectIdentifier as? NSDecimalNumber
                module.radio = vehicleProfileRadio
                dataStore?.stash(objectContext: managedObjectContext) { error in
                    completion(fetchResult, error)
                }
            }
        }
    }
}
