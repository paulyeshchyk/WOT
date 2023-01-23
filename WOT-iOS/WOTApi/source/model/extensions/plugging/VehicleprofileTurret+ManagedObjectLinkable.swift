//
//  VehicleprofileTurret+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileTurret + ManagedObjectPinProtocol

extension VehicleprofileTurret: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileTurret + ManagedObjectPlugProtocol

extension VehicleprofileTurret: ManagedObjectPlugProtocol {

    public func plug(pin _: ManagedObjectPinProtocol?, intoSocket _: JointSocketProtocol?) {
        //
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {
        //
    }
}
