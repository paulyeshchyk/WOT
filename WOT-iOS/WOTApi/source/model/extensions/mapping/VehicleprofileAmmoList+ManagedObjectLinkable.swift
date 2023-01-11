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
    public func doLinking(_ element: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        if let ammo = element as? VehicleprofileAmmo {
            addToVehicleprofileAmmo(ammo)
        }
    }

    public func doLinking(_: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
