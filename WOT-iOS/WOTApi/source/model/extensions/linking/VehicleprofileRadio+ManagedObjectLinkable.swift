//
//  VehicleprofileRadio+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileRadio + ManagedObjectPinProtocol

extension VehicleprofileRadio: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileRadio + ManagedObjectSocketProtocol

extension VehicleprofileRadio: ManagedObjectSocketProtocol {

    public func doLinking(pin _: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
