//
//  ModuleVehicleprofileEngineManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModuleVehicleprofileEngineManagedObjectExtractor: ManagedObjectExtractable {
    public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }

    // MARK: Public

    public func extractJSON(from: JSON) -> JSON? {
        return from[#keyPath(Vehicleprofile.engine)] as? JSON
    }
}
