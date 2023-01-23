//
//  VehicleprofileTurret+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension VehicleprofileTurret {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        // tag was used when parsed response vehicleprofile-suspension
        switch forType {
        case .external: return #keyPath(VehicleprofileTurret.turret_id)
        case .internal: return #keyPath(VehicleprofileTurret.tag)
        default: fatalError("unknown type should never be used")
        }
    }
}
