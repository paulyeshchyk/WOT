//
//  VehicleprofileSuspension+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileSuspension + ManagedObjectLinkable

extension VehicleprofileSuspension: ManagedObjectLinkable {}

// MARK: - VehicleprofileSuspension + ManagedObjectLinkHostable

extension VehicleprofileSuspension: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
