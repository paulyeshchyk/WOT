//
//  Module+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - Module + ManagedObjectPinProtocol

extension Module: ManagedObjectPinProtocol {}

// MARK: - Module + ManagedObjectSocketProtocol

extension Module: ManagedObjectSocketProtocol {

    public func doLinking(pin: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        //
        if let engine = pin as? VehicleprofileEngine {
            engine.engine_id = socket.identifier as? NSDecimalNumber
            self.engine = engine
        }
        //
        if let gun = pin as? VehicleprofileGun {
            gun.gun_id = socket.identifier as? NSDecimalNumber
            self.gun = gun
        }
        //
        if let radio = pin as? VehicleprofileRadio {
            radio.radio_id = socket.identifier as? NSDecimalNumber
            self.radio = radio
        }
        //
        if let suspension = pin as? VehicleprofileSuspension {
            suspension.suspension_id = socket.identifier as? NSDecimalNumber
            self.suspension = suspension
        }
        //
        if let turret = pin as? VehicleprofileTurret {
            turret.turret_id = socket.identifier as? NSDecimalNumber
            self.turret = turret
        }
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
