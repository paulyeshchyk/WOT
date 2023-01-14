//
//  VehicleprofileAmmoPenetration+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoPenetration + ManagedObjectPinProtocol

extension VehicleprofileAmmoPenetration: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmoPenetration + ManagedObjectPlugProtocol

extension VehicleprofileAmmoPenetration: ManagedObjectPlugProtocol {

    public func plug(pin _: ManagedObjectPinProtocol, intoSocket _: JointSocketProtocol) {
        //
    }

    public func plug(pins _: [ManagedObjectPinProtocol], intoSocket _: JointSocketProtocol) {
        //
    }
}
