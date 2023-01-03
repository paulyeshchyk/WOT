//
//  VehicleprofileModuleTurretManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleTurretManagedObjectCreator: ManagedObjectExtractable {
    public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

    public func extractJSON(from: JSON) -> JSON? {
        return from[#keyPath(Vehicleprofile.turret)] as? JSON
    }
}
