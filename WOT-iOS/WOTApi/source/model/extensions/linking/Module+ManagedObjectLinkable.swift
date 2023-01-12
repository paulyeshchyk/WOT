//
//  Module+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - Module + ManagedObjectPinProtocol

extension Module: ManagedObjectPinProtocol {}

// MARK: - Module + ManagedObjectSocketProtocol

extension Module: ManagedObjectSocketProtocol {

    // swiftlint:disable cyclomatic_complexity
    public func doLinking(pin: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        switch socket.keypath as? String {
        case #keyPath(Module.engine):
            engine = pin as? VehicleprofileEngine
            engine?.engine_id = socket.identifier as? NSDecimalNumber
        case #keyPath(Module.radio):
            radio = pin as? VehicleprofileRadio
            radio?.radio_id = socket.identifier as? NSDecimalNumber
        case #keyPath(Module.suspension):
            suspension = pin as? VehicleprofileSuspension
            suspension?.suspension_id = socket.identifier as? NSDecimalNumber
        case #keyPath(Module.turret):
            turret = pin as? VehicleprofileTurret
            turret?.turret_id = socket.identifier as? NSDecimalNumber
        case #keyPath(Module.gun):
            gun = pin as? VehicleprofileGun
            gun?.gun_id = socket.identifier as? NSDecimalNumber
        default:
            assertionFailure("undefiend field \(String(describing: socket))")
        }
        // swiftlint:enable cyclomatic_complexity
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
