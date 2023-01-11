//
//  VehicleprofileEngine+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileEngine + ManagedObjectPinProtocol

extension VehicleprofileEngine: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileEngine + ManagedObjectSocketProtocol

extension VehicleprofileEngine: ManagedObjectSocketProtocol {

    public func doLinking(pin _: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
