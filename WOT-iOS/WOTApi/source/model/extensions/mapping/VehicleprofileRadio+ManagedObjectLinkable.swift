//
//  VehicleprofileRadio+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileRadio + ManagedObjectLinkable

extension VehicleprofileRadio: ManagedObjectLinkable {}

// MARK: - VehicleprofileRadio + ManagedObjectLinkHostable

extension VehicleprofileRadio: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}