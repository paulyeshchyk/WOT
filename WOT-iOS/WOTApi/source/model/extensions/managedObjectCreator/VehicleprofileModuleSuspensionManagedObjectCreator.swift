//
//  VehicleprofileModuleSuspensionPredicateComposer.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleSuspensionManagedObjectCreator: ManagedObjectExtractable {
    public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

    public func extractJSON(from: JSON) -> JSON? {
        return from[#keyPath(Vehicleprofile.suspension)] as? JSON
    }
}
