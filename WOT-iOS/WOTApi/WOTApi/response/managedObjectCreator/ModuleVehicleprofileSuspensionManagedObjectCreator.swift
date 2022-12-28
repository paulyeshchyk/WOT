//
//  ModuleVehicleprofileSuspensionManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModuleVehicleprofileSuspensionManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.suspension)] as? JSON
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        guard let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileSuspension.self))
            return
        }
        guard let module = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? Module else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Module.self))
            return
        }
        vehicleProfileSuspension.suspension_id = self.mappedObjectIdentifier as? NSDecimalNumber
        module.suspension = vehicleProfileSuspension
        dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
