//
//  VehicleprofileGun+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileGun + ManagedObjectLinkable

extension VehicleprofileGun: ManagedObjectLinkable {}

// MARK: - VehicleprofileGun + ManagedObjectLinkHostable

extension VehicleprofileGun: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
