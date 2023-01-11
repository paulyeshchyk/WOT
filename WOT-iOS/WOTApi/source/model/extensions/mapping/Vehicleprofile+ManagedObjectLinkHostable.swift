//
//  Vehicleprofile+ManagedObjectLinkHostable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

import ContextSDK

// MARK: - Vehicleprofile + ManagedObjectLinkable

extension Vehicleprofile: ManagedObjectLinkable {}

// MARK: - Vehicleprofile + ManagedObjectLinkHostable

extension Vehicleprofile: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, socket _: ManagedObjectLinkerSocketProtocol) {
        if let turret = element as? VehicleprofileTurret {
            self.turret = turret
        }
        if let suspension = element as? VehicleprofileSuspension {
            self.suspension = suspension
        }
        if let radio = element as? VehicleprofileRadio {
            self.radio = radio
        }
        if let gun = element as? VehicleprofileGun {
            self.gun = gun
        }
        if let engine = element as? VehicleprofileEngine {
            self.engine = engine
        }
        if let ammo = element as? VehicleprofileAmmoList {
            self.ammo = ammo
        }
        if let armor = element as? VehicleprofileArmorList {
            self.armor = armor
        }
        if let modules = element as? VehicleprofileModule {
            self.modules = modules
        }
    }

    public func doLinking(_: [ManagedObjectLinkable], socket _: ManagedObjectLinkerSocketProtocol) {
        //
    }
}
