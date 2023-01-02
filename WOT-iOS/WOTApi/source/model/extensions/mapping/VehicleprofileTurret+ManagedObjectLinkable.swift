//
//  VehicleprofileTurret+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

extension VehicleprofileTurret: ManagedObjectLinkable {}

extension VehicleprofileTurret: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
