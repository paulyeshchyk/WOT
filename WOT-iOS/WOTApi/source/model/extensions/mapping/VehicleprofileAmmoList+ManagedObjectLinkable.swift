//
//  VehicleprofileAmmoList+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoList + ManagedObjectLinkable

extension VehicleprofileAmmoList: ManagedObjectLinkable {}

// MARK: - VehicleprofileAmmoList + ManagedObjectLinkHostable

extension VehicleprofileAmmoList: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, socket _: ManagedObjectLinkerSocketProtocol) {
        if let ammo = element as? VehicleprofileAmmo {
            addToVehicleprofileAmmo(ammo)
        }
    }

    public func doLinking(_: [ManagedObjectLinkable], socket _: ManagedObjectLinkerSocketProtocol) {
        //
    }
}
