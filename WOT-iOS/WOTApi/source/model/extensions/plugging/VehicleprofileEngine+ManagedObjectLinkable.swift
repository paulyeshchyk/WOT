//
//  VehicleprofileEngine+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileEngine + ManagedObjectPinProtocol

extension VehicleprofileEngine: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileEngine + ManagedObjectPlugProtocol

extension VehicleprofileEngine: ManagedObjectPlugProtocol {

    public func plug(pin _: ManagedObjectPinProtocol?, intoSocket _: JointSocketProtocol?) {
        //
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {
        //
    }
}
