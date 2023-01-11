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
    public func doLinking(_ element: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        //
        if let engine = element as? VehicleprofileEngine {
            engine.engine_id = socket.identifier as? NSDecimalNumber
            self.engine = engine
        }
        //
        if let gun = element as? VehicleprofileGun {
            gun.gun_id = socket.identifier as? NSDecimalNumber
            self.gun = gun
        }
        //
        if let radio = element as? VehicleprofileRadio {
            radio.radio_id = socket.identifier as? NSDecimalNumber
            self.radio = radio
        }
        //
        if let suspension = element as? VehicleprofileSuspension {
            suspension.suspension_id = socket.identifier as? NSDecimalNumber
            self.suspension = suspension
        }
        //
        if let turret = element as? VehicleprofileTurret {
            turret.turret_id = socket.identifier as? NSDecimalNumber
            self.turret = turret
        }
    }

    public func doLinking(_: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
