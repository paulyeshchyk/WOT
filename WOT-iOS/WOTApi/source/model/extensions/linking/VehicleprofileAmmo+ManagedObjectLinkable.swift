//
//  VehicleprofileAmmo+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileAmmo + ManagedObjectPinProtocol

extension VehicleprofileAmmo: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileAmmo + ManagedObjectPlugProtocol

extension VehicleprofileAmmo: ManagedObjectPlugProtocol {

    public func plug(pin: ManagedObjectPinProtocol, intoSocket: JointSocketProtocol) {
        //
        switch intoSocket.keypath as? String {
        case #keyPath(VehicleprofileAmmo.damage): damage = pin as? VehicleprofileAmmoDamage
        case #keyPath(VehicleprofileAmmo.penetration): penetration = pin as? VehicleprofileAmmoPenetration
        default:
            assertionFailure("undefiend field \(String(describing: intoSocket))")
        }
    }

    public func plug(pins _: [ManagedObjectPinProtocol], intoSocket _: JointSocketProtocol) {
        //
    }
}
