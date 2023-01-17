//
//  Module+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - Module + ManagedObjectPinProtocol

extension Module: ManagedObjectPinProtocol {}

// MARK: - Module + ManagedObjectPlugProtocol

extension Module: ManagedObjectPlugProtocol {

    // swiftlint:disable cyclomatic_complexity
    public func plug(pin: ManagedObjectPinProtocol?, intoSocket: JointSocketProtocol?) {
        switch intoSocket?.keypath as? String {
        case #keyPath(Module.engine):
            engine = pin as? VehicleprofileEngine
            engine?.engine_id = intoSocket?.identifier as? NSDecimalNumber
        case #keyPath(Module.radio):
            radio = pin as? VehicleprofileRadio
            radio?.radio_id = intoSocket?.identifier as? NSDecimalNumber
        case #keyPath(Module.suspension):
            suspension = pin as? VehicleprofileSuspension
            suspension?.suspension_id = intoSocket?.identifier as? NSDecimalNumber
        case #keyPath(Module.turret):
            turret = pin as? VehicleprofileTurret
            turret?.turret_id = intoSocket?.identifier as? NSDecimalNumber
        case #keyPath(Module.gun):
            gun = pin as? VehicleprofileGun
            gun?.gun_id = intoSocket?.identifier as? NSDecimalNumber
        default:
            assertionFailure("undefiend field \(String(describing: intoSocket))")
        }
        // swiftlint:enable cyclomatic_complexity
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {
        //
    }
}
