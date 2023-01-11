//
//  VehicleprofileSuspension+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileSuspension + ManagedObjectPinProtocol

extension VehicleprofileSuspension: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileSuspension + ManagedObjectSocketProtocol

extension VehicleprofileSuspension: ManagedObjectSocketProtocol {

    public func doLinking(pin _: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
