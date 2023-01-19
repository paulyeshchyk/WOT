//
//  VehicleprofileRadio+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileRadio + ManagedObjectPinProtocol

extension VehicleprofileRadio: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileRadio + ManagedObjectPlugProtocol

extension VehicleprofileRadio: ManagedObjectPlugProtocol {

    public func plug(pin _: ManagedObjectPinProtocol?, intoSocket _: JointSocketProtocol?) {
        //
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {
        //
    }
}
