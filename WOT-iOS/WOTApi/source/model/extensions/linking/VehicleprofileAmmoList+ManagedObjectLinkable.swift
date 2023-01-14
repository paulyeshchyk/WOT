//
//  VehicleprofileAmmoList+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoList + ManagedObjectPinProtocol

extension VehicleprofileAmmoList: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmoList + ManagedObjectPlugProtocol

extension VehicleprofileAmmoList: ManagedObjectPlugProtocol {

    public func plug(pin: ManagedObjectPinProtocol, intoSocket _: JointSocketProtocol) {
        if let ammo = pin as? VehicleprofileAmmo {
            addToVehicleprofileAmmo(ammo)
        }
    }

    public func plug(pins _: [ManagedObjectPinProtocol], intoSocket _: JointSocketProtocol) {
        //
    }
}
