//
//  VehicleprofileEngine+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileEngine + ManagedObjectLinkable

extension VehicleprofileEngine: ManagedObjectLinkable {}

// MARK: - VehicleprofileEngine + ManagedObjectLinkHostable

extension VehicleprofileEngine: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, socket _: ManagedObjectLinkerSocketProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], socket _: ManagedObjectLinkerSocketProtocol) {
        //
    }
}
