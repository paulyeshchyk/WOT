//
//  VehicleprofileAmmo+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmo + ManagedObjectLinkable

extension VehicleprofileAmmo: ManagedObjectLinkable {}

// MARK: - VehicleprofileAmmo + ManagedObjectLinkHostable

extension VehicleprofileAmmo: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, anchor _: ManagedObjectLinkerAnchorProtocol) {
        if let damage = element as? VehicleprofileAmmoDamage {
            self.damage = damage
        }
        if let penetration = element as? VehicleprofileAmmoPenetration {
            self.penetration = penetration
        }
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
