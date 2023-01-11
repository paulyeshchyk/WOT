//
//  VehicleprofileArmorList+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileArmorList + ManagedObjectPinProtocol

extension VehicleprofileArmorList: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileArmorList + ManagedObjectSocketProtocol

extension VehicleprofileArmorList: ManagedObjectSocketProtocol {
    public func doLinking(_ element: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        if let armor = element as? VehicleprofileArmor {
            if (socket.keypath as? String) == #keyPath(VehicleprofileArmorList.turret) {
                turret = armor
            }
            if (socket.keypath as? String) == #keyPath(VehicleprofileArmorList.hull) {
                hull = armor
            }
        }
    }

    public func doLinking(_: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
