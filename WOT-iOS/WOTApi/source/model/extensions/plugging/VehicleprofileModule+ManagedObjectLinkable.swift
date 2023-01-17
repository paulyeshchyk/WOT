//
//  VehicleprofileModule+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileModule + ManagedObjectPinProtocol

extension VehicleprofileModule: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileModule + ManagedObjectPlugProtocol

extension VehicleprofileModule: ManagedObjectPlugProtocol {

    // swiftlint:disable cyclomatic_complexity
    public func plug(pin: ManagedObjectPinProtocol, intoSocket: JointSocketProtocol) {
        switch intoSocket.keypath as? String {
        case #keyPath(VehicleprofileModule.gun_id):
            vehicleGun = pin as? VehicleprofileGun
            vehicleGun?.gun_id = intoSocket.identifier as? NSDecimalNumber
        case #keyPath(VehicleprofileModule.engine_id):
            vehicleEngine = pin as? VehicleprofileEngine
            vehicleEngine?.engine_id = intoSocket.identifier as? NSDecimalNumber
        case #keyPath(VehicleprofileModule.suspension_id):
            vehicleChassis = pin as? VehicleprofileSuspension
            vehicleChassis?.suspension_id = intoSocket.identifier as? NSDecimalNumber
        case #keyPath(VehicleprofileModule.radio_id):
            vehicleRadio = pin as? VehicleprofileRadio
            vehicleRadio?.radio_id = intoSocket.identifier as? NSDecimalNumber
        case #keyPath(VehicleprofileModule.turret_id):
            vehicleTurret = pin as? VehicleprofileTurret
            vehicleTurret?.turret_id = intoSocket.identifier as? NSDecimalNumber
        default:
            assertionFailure("undefiend field \(String(describing: intoSocket))")
        }
        // swiftlint:enable cyclomatic_complexity
    }

    public func plug(pins _: [ManagedObjectPinProtocol], intoSocket _: JointSocketProtocol) {
        //
    }
}
