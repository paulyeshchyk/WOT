//
//  VehicleprofileAmmoDamage+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoDamage + ManagedObjectPinProtocol

extension VehicleprofileAmmoDamage: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmoDamage + ManagedObjectSocketProtocol

extension VehicleprofileAmmoDamage: ManagedObjectSocketProtocol {

    public func doLinking(pin _: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
