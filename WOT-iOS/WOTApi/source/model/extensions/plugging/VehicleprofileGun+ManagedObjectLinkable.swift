//
//  VehicleprofileGun+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileGun + ManagedObjectPinProtocol

extension VehicleprofileGun: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileGun + ManagedObjectPlugProtocol

extension VehicleprofileGun: ManagedObjectPlugProtocol {

    public func plug(pin _: ManagedObjectPinProtocol, intoSocket _: JointSocketProtocol) {
        //
    }

    public func plug(pins _: [ManagedObjectPinProtocol], intoSocket _: JointSocketProtocol) {
        //
    }
}
