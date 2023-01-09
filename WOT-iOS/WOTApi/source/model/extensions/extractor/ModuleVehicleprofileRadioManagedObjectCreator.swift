//
//  ModuleVehicleprofileRadioManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModuleVehicleprofileRadioManagedObjectCreator: ManagedObjectExtractable {

    public var linkerPrimaryKeyType: PrimaryKeyType {
        return .internal
    }

    public var jsonKeyPath: KeypathType? {
        #keyPath(Vehicleprofile.radio)
    }
}
