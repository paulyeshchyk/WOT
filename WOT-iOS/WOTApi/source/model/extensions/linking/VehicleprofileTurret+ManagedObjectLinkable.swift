//
//  VehicleprofileTurret+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileTurret + ManagedObjectPinProtocol

extension VehicleprofileTurret: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileTurret + ManagedObjectSocketProtocol

extension VehicleprofileTurret: ManagedObjectSocketProtocol {

    public func doLinking(pin _: ManagedObjectPinProtocol, socket _: JointSocketProtocol) {
        //
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
