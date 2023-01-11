//
//  VehicleprofileGun+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileGun + ManagedObjectPinProtocol

extension VehicleprofileGun: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileGun + ManagedObjectSocketProtocol

extension VehicleprofileGun: ManagedObjectSocketProtocol {

    public func doLinking(pin _: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
