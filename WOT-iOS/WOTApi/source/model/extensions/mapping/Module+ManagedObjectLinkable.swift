//
//  Module+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

extension Module: ManagedObjectLinkable {}

extension Module: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, anchor: ManagedObjectLinkerAnchorProtocol) {
        //
        if let engine = element as? VehicleprofileEngine {
            engine.engine_id = anchor.identifier as? NSDecimalNumber
            self.engine = engine
        }
        //
        if let gun = element as? VehicleprofileGun {
            gun.gun_id = anchor.identifier as? NSDecimalNumber
            self.gun = gun
        }
        //
        if let radio = element as? VehicleprofileRadio {
            radio.radio_id = anchor.identifier as? NSDecimalNumber
            self.radio = radio
        }
        //
        if let suspension = element as? VehicleprofileSuspension {
            suspension.suspension_id = anchor.identifier as? NSDecimalNumber
            self.suspension = suspension
        }
        //
        if let turret = element as? VehicleprofileTurret {
            turret.turret_id = anchor.identifier as? NSDecimalNumber
            self.turret = turret
        }
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
