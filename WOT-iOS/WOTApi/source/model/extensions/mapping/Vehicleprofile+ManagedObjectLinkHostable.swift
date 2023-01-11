//
//  Vehicleprofile+ManagedObjectLinkHostable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

import ContextSDK

// MARK: - Vehicleprofile + ManagedObjectPinProtocol

extension Vehicleprofile: ManagedObjectPinProtocol {}

// MARK: - Vehicleprofile + ManagedObjectSocketProtocol

extension Vehicleprofile: ManagedObjectSocketProtocol {

    public func doLinking(pin: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        if let turret = pin as? VehicleprofileTurret {
            self.turret = turret
        }
        if let suspension = pin as? VehicleprofileSuspension {
            self.suspension = suspension
        }
        if let radio = pin as? VehicleprofileRadio {
            self.radio = radio
        }
        if let gun = pin as? VehicleprofileGun {
            self.gun = gun
        }
        if let engine = pin as? VehicleprofileEngine {
            self.engine = engine
        }
        if let ammo = pin as? VehicleprofileAmmoList {
            self.ammo = ammo
        }
        if let armor = pin as? VehicleprofileArmorList {
            self.armor = armor
        }
        if let modules = pin as? VehicleprofileModule {
            self.modules = modules
        }
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
