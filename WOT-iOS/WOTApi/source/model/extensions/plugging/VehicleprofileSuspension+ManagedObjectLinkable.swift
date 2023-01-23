//
//  VehicleprofileSuspension+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileSuspension + ManagedObjectPinProtocol

extension VehicleprofileSuspension: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileSuspension + ManagedObjectPlugProtocol

extension VehicleprofileSuspension: ManagedObjectPlugProtocol {

    public func plug(pin _: ManagedObjectPinProtocol?, intoSocket _: JointSocketProtocol?) {
        //
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {
        //
    }
}
