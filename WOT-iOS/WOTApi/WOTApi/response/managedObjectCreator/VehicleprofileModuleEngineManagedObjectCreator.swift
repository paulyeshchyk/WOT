//
//  VehicleprofileModuleEngineManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleEngineManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.engine)] as? JSON
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let managedObjectContext = fetchResult.managedObjectContext
        guard let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
            return
        }
        guard let module = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileModule else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
            return
        }
        vehicleProfileEngine.engine_id = mappedObjectIdentifier as? NSDecimalNumber
        module.vehicleEngine = vehicleProfileEngine
        dataStore?.stash(objectContext: managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}

public class VehicleprofileModuleEnginePredicateComposer: MasterAsSecondaryLinkedRemoteAsPrimaryRuleBuilder {}
