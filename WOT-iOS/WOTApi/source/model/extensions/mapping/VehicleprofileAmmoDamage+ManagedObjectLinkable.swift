//
//  VehicleprofileAmmoDamage+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoDamage + ManagedObjectLinkable

extension VehicleprofileAmmoDamage: ManagedObjectLinkable {}

// MARK: - VehicleprofileAmmoDamage + ManagedObjectLinkHostable

extension VehicleprofileAmmoDamage: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}