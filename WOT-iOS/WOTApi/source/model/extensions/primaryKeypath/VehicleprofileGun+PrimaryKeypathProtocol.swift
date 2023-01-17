//
//  VehicleprofileGun+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension VehicleprofileGun {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        // id was used when quering remote module
        switch forType {
        case .external: return #keyPath(VehicleprofileGun.gun_id)
        case .internal: return #keyPath(VehicleprofileGun.tag)
        default: fatalError("unknown type should never be used")
        }
    }
}
