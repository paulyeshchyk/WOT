//
//  VehicleprofileArmor+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileArmor + ManagedObjectLinkable

extension VehicleprofileArmor: ManagedObjectLinkable {}

// MARK: - VehicleprofileArmor + ManagedObjectLinkHostable

extension VehicleprofileArmor: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], anchor _: ManagedObjectLinkerAnchorProtocol) {
        //
    }
}
