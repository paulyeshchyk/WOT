//
//  VehicleprofileAmmoListAmmoManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileAmmoListAmmoManagedObjectCreator: ManagedObjectExtractable {

    public var linkerPrimaryKeyType: PrimaryKeyType {
        return .external
    }

    public var jsonKeyPath: KeypathType? {
        nil
    }
}
