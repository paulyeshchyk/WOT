//
//  VehicleprofileAmmoPenetration+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoPenetration + ManagedObjectPinProtocol

extension VehicleprofileAmmoPenetration: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmoPenetration + ManagedObjectSocketProtocol

extension VehicleprofileAmmoPenetration: ManagedObjectSocketProtocol {

    public func doLinking(pin _: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
