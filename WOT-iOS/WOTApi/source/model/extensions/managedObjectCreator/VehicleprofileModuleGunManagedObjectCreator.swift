//
//  VehicleprofileModuleGunManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileModuleGunManagedObjectCreator: ManagedObjectLinker {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json[#keyPath(Vehicleprofile.gun)] as? JSON
    }
}
