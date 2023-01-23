//
//  Vehicles+PrimaryKeypathProtocol.swift
//  WOTApi
//
//  Created by Paul on 17.01.23.
//

extension Vehicles {

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(Vehicles.tank_id)
        case .internal: return #keyPath(Vehicles.tank_id)
        default: fatalError("unknown type should never be used")
        }
    }
}
