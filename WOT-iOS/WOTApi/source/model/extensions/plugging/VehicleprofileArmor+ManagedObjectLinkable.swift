//
//  VehicleprofileArmor+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileArmor + ManagedObjectPinProtocol

extension VehicleprofileArmor: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileArmor + ManagedObjectPlugProtocol

extension VehicleprofileArmor: ManagedObjectPlugProtocol {

    public func plug(pin _: ManagedObjectPinProtocol?, intoSocket _: JointSocketProtocol?) {
        //
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {
        //
    }
}
