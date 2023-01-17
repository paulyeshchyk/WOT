//
//  VehicleprofileRadio+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension VehicleprofileRadio {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        // tag was used when parsed response vehicleprofile-radio
        switch forType {
        case .external: return #keyPath(VehicleprofileRadio.radio_id)
        case .internal: return #keyPath(VehicleprofileRadio.tag)
        default: fatalError("unknown type should never be used")
        }
    }
}
