//
//  VehicleprofileAmmoDamage+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmoDamage + ManagedObjectPinProtocol

extension VehicleprofileAmmoDamage: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmoDamage + ManagedObjectPlugProtocol

extension VehicleprofileAmmoDamage: ManagedObjectPlugProtocol {

    public func plug(pin _: ManagedObjectPinProtocol?, intoSocket _: JointSocketProtocol?) {
        //
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {
        //
    }
}
