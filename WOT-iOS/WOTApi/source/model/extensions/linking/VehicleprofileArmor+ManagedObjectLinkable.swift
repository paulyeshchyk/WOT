//
//  VehicleprofileArmor+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileArmor + ManagedObjectPinProtocol

extension VehicleprofileArmor: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileArmor + ManagedObjectSocketProtocol

extension VehicleprofileArmor: ManagedObjectSocketProtocol {

    public func doLinking(pin _: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}