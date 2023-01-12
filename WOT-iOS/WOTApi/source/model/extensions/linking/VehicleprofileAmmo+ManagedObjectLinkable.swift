//
//  VehicleprofileAmmo+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmo + ManagedObjectPinProtocol

extension VehicleprofileAmmo: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmo + ManagedObjectSocketProtocol

extension VehicleprofileAmmo: ManagedObjectSocketProtocol {

    public func doLinking(pin: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        //
        switch socket.keypath as? String {
        case #keyPath(VehicleprofileAmmo.damage): damage = pin as? VehicleprofileAmmoDamage
        case #keyPath(VehicleprofileAmmo.penetration): penetration = pin as? VehicleprofileAmmoPenetration
        default:
            assertionFailure("undefiend field \(String(describing: socket))")
        }
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
