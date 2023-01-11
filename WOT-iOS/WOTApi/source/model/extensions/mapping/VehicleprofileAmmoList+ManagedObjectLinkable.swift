//
//  VehicleprofileAmmoList+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoList + ManagedObjectPinProtocol

extension VehicleprofileAmmoList: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmoList + ManagedObjectSocketProtocol

extension VehicleprofileAmmoList: ManagedObjectSocketProtocol {

    public func doLinking(pin: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        if let ammo = pin as? VehicleprofileAmmo {
            addToVehicleprofileAmmo(ammo)
        }
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
