//
//  VehicleprofileAmmoPenetration+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoPenetration + ManagedObjectLinkable

extension VehicleprofileAmmoPenetration: ManagedObjectLinkable {}

// MARK: - VehicleprofileAmmoPenetration + ManagedObjectLinkHostable

extension VehicleprofileAmmoPenetration: ManagedObjectLinkHostable {
    public func doLinking(_: ManagedObjectLinkable, socket _: ManagedObjectLinkerSocketProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectLinkable], socket _: ManagedObjectLinkerSocketProtocol) {
        //
    }
}
