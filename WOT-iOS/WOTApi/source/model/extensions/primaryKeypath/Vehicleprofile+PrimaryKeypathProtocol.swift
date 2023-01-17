//
//  Vehicleprofile+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension Vehicleprofile {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(Vehicleprofile.hashName)
        case .internal: return #keyPath(Vehicleprofile.hashName)
        default: fatalError("unknown type should never be used")
        }
    }
}
