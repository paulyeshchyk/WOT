//
//  VehicleprofileEngine+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension VehicleprofileEngine {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        // tag was used when parsed response vehicleprofile-engine
        switch forType {
        case .external: return #keyPath(VehicleprofileEngine.engine_id)
        case .internal: return #keyPath(VehicleprofileEngine.tag)
        default: fatalError("unknown type should never be used")
        }
    }
}
