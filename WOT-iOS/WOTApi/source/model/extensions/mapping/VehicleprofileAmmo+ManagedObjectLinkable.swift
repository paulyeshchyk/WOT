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
    public func doLinking(_ element: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        if let damage = element as? VehicleprofileAmmoDamage {
            self.damage = damage
        }
        if let penetration = element as? VehicleprofileAmmoPenetration {
            self.penetration = penetration
        }
    }

    public func doLinking(_: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
