//
//  VehicleprofileModule+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension VehicleprofileModule {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(VehicleprofileModule.module_id)
        case .internal: return #keyPath(VehicleprofileModule.module_id)
        default: fatalError("unknown type should never be used")
        }
    }
}
