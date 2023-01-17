//
//  VehicleprofileArmorList+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileArmorList + ManagedObjectPinProtocol

extension VehicleprofileArmorList: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileArmorList + ManagedObjectPlugProtocol

extension VehicleprofileArmorList: ManagedObjectPlugProtocol {

    public func plug(pin: ManagedObjectPinProtocol, intoSocket: JointSocketProtocol) {
        //
        switch intoSocket.keypath as? String {
        case #keyPath(VehicleprofileArmorList.turret): turret = pin as? VehicleprofileArmor
        case #keyPath(VehicleprofileArmorList.hull): hull = pin as? VehicleprofileArmor
        default:
            assertionFailure("undefiend field \(String(describing: intoSocket))")
        }
    }

    public func plug(pins _: [ManagedObjectPinProtocol], intoSocket _: JointSocketProtocol) {
        //
    }
}
