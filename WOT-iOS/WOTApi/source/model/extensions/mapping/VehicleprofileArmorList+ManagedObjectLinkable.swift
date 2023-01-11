//
//  VehicleprofileArmorList+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileArmorList + ManagedObjectLinkable

extension VehicleprofileArmorList: ManagedObjectLinkable {}

// MARK: - VehicleprofileArmorList + ManagedObjectLinkHostable

extension VehicleprofileArmorList: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, socket: ManagedObjectLinkerSocketProtocol) {
        if let armor = element as? VehicleprofileArmor {
            if (socket.keypath as? String) == #keyPath(VehicleprofileArmorList.turret) {
                turret = armor
            }
            if (socket.keypath as? String) == #keyPath(VehicleprofileArmorList.hull) {
                hull = armor
            }
        }
    }

    public func doLinking(_: [ManagedObjectLinkable], socket _: ManagedObjectLinkerSocketProtocol) {
        //
    }
}
