//
//  VehicleprofileArmorList+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

extension VehicleprofileArmorList: ManagedObjectLinkable {}

extension VehicleprofileArmorList: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, anchor: ManagedObjectLinkerAnchorProtocol) {
        if let armor = element as? VehicleprofileArmor {
            if (anchor as? String) == #keyPath(VehicleprofileArmorList.turret) {
                turret = armor
            }
            if (anchor as? String) == #keyPath(VehicleprofileArmorList.hull) {
                hull = armor
            }
        }
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
