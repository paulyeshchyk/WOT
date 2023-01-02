//
//  VehicleprofileAmmoDamage+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

extension VehicleprofileAmmoDamage: ManagedObjectLinkable {}

extension VehicleprofileAmmoDamage: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
