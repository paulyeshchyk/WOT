//
//  VehicleprofileArmorList+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileArmorList + ManagedObjectPinProtocol

extension VehicleprofileArmorList: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileArmorList + ManagedObjectSocketProtocol

extension VehicleprofileArmorList: ManagedObjectSocketProtocol {

    public func doLinking(pin: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        //
        switch socket.keypath as? String {
        case #keyPath(VehicleprofileArmorList.turret): turret = pin as? VehicleprofileArmor
        case #keyPath(VehicleprofileArmorList.hull): hull = pin as? VehicleprofileArmor
        default:
            assertionFailure("undefiend field \(String(describing: socket))")
        }
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
