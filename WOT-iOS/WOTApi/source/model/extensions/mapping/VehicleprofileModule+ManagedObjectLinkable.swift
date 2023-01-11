//
//  VehicleprofileModule+ManagedObjectLinkable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - VehicleprofileModule + ManagedObjectPinProtocol

extension VehicleprofileModule: ManagedObjectPinProtocol {}

// MARK: - VehicleprofileModule + ManagedObjectSocketProtocol

extension VehicleprofileModule: ManagedObjectSocketProtocol {

    // swiftlint:disable cyclomatic_complexity
    public func doLinking(pin: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        switch socket.keypath as? String {
        case #keyPath(VehicleprofileModule.gun_id):
            vehicleGun = pin as? VehicleprofileGun
            vehicleGun?.gun_id = socket.identifier as? NSDecimalNumber
        case #keyPath(VehicleprofileModule.engine_id):
            vehicleEngine = pin as? VehicleprofileEngine
            vehicleEngine?.engine_id = socket.identifier as? NSDecimalNumber
        case #keyPath(VehicleprofileModule.suspension_id):
            vehicleChassis = pin as? VehicleprofileSuspension
            vehicleChassis?.suspension_id = socket.identifier as? NSDecimalNumber
        case #keyPath(VehicleprofileModule.radio_id):
            vehicleRadio = pin as? VehicleprofileRadio
            vehicleRadio?.radio_id = socket.identifier as? NSDecimalNumber
        case #keyPath(VehicleprofileModule.turret_id):
            vehicleTurret = pin as? VehicleprofileTurret
            vehicleTurret?.turret_id = socket.identifier as? NSDecimalNumber
        default:
            assertionFailure("undefiend field \(String(describing: socket))")
        }
        // swiftlint:enable cyclomatic_complexity
    }

    public func doLinking(pins _: [ManagedObjectPinProtocol], socket _: JointSocketProtocol) {
        //
    }
}
