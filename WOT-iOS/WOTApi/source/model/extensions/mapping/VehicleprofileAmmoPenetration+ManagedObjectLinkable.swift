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
    public func doLinking(_: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(_: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
