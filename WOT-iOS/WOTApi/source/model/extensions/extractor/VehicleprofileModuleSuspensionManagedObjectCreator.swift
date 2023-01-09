//
//  VehicleprofileModuleSuspensionPredicateComposer.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleSuspensionManagedObjectCreator: ManagedObjectExtractable {

    public var linkerPrimaryKeyType: PrimaryKeyType {
        return .external
    }

    public var jsonKeyPath: KeypathType? {
        #keyPath(Vehicleprofile.suspension)
    }
}
