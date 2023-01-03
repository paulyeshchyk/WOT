//
//  VehicleprofileModuleGunManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleGunManagedObjectExtractor: ManagedObjectExtractable {
    public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    public func extractJSON(from: JSON) -> JSON? {
        return from[#keyPath(Vehicleprofile.gun)] as? JSON
    }
}
