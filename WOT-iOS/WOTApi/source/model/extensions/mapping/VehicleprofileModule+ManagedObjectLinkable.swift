//
//  VehicleprofileModule+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileModule + ManagedObjectLinkable

extension VehicleprofileModule: ManagedObjectLinkable {}

// MARK: - VehicleprofileModule + ManagedObjectLinkHostable

extension VehicleprofileModule: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, anchor: ManagedObjectLinkerAnchorProtocol) {
        //
        if let vehicleGun = element as? VehicleprofileGun {
            vehicleGun.gun_id = anchor.identifier as? NSDecimalNumber
            self.vehicleGun = vehicleGun
        }
        //
        if let vehicleEngine = element as? VehicleprofileEngine {
            vehicleEngine.engine_id = anchor.identifier as? NSDecimalNumber
            self.vehicleEngine = vehicleEngine
        }
        //
        if let vehicleChassis = element as? VehicleprofileSuspension {
            vehicleChassis.suspension_id = anchor.identifier as? NSDecimalNumber
            self.vehicleChassis = vehicleChassis
        }
        //
        if let vehicleRadio = element as? VehicleprofileRadio {
            vehicleRadio.radio_id = anchor.identifier as? NSDecimalNumber

            self.vehicleRadio = vehicleRadio
        }
        //
        if let vehicleTurret = element as? VehicleprofileTurret {
            vehicleTurret.turret_id = anchor.identifier as? NSDecimalNumber

            self.vehicleTurret = vehicleTurret
        }
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
