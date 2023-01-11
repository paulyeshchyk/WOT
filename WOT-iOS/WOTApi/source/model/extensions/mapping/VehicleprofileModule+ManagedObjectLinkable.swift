//
//  VehicleprofileModule+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileModule + ManagedObjectPinProtocol

extension VehicleprofileModule: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileModule + ManagedObjectSocketProtocol

extension VehicleprofileModule: ManagedObjectSocketProtocol {

    public func doLinking(pin: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        //
        if let vehicleGun = pin as? VehicleprofileGun {
            vehicleGun.gun_id = socket.identifier as? NSDecimalNumber
            self.vehicleGun = vehicleGun
        }
        //
        if let vehicleEngine = pin as? VehicleprofileEngine {
            vehicleEngine.engine_id = socket.identifier as? NSDecimalNumber
            self.vehicleEngine = vehicleEngine
        }
        //
        if let vehicleChassis = pin as? VehicleprofileSuspension {
            vehicleChassis.suspension_id = socket.identifier as? NSDecimalNumber
            self.vehicleChassis = vehicleChassis
        }
        //
        if let vehicleRadio = pin as? VehicleprofileRadio {
            vehicleRadio.radio_id = socket.identifier as? NSDecimalNumber

            self.vehicleRadio = vehicleRadio
        }
        //
        if let vehicleTurret = pin as? VehicleprofileTurret {
            vehicleTurret.turret_id = socket.identifier as? NSDecimalNumber

            self.vehicleTurret = vehicleTurret
        }
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
