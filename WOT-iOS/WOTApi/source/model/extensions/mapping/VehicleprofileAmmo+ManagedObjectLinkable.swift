//
//  VehicleprofileAmmo+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmo + ManagedObjectPinProtocol

extension VehicleprofileAmmo: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmo + ManagedObjectSocketProtocol

extension VehicleprofileAmmo: ManagedObjectSocketProtocol {

    public func doLinking(pin: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        if let damage = pin as? VehicleprofileAmmoDamage {
            self.damage = damage
        }
        if let penetration = pin as? VehicleprofileAmmoPenetration {
            self.penetration = penetration
        }
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
