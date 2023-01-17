//
//  VehicleprofileSuspension+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension VehicleprofileSuspension {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        // tag was used when parsed response vehicleprofile-suspension

        switch forType {
        case .external: return #keyPath(VehicleprofileSuspension.suspension_id)
        case .internal: return #keyPath(VehicleprofileSuspension.tag)
        default: fatalError("unknown type should never be used")
        }
    }
}
