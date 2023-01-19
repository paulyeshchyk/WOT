//
//  Vehicleprofile+ManagedObjectLinkHostable.swift
//  WOTApi
//
//  Created by Paul on 2.01.23.
//

// MARK: - Vehicleprofile + ManagedObjectPinProtocol

extension Vehicleprofile: ManagedObjectPinProtocol {}

// MARK: - Vehicleprofile + ManagedObjectPlugProtocol

extension Vehicleprofile: ManagedObjectPlugProtocol {

    // swiftlint:disable cyclomatic_complexity
    public func plug(pin: ManagedObjectPinProtocol?, intoSocket: JointSocketProtocol?) {
        //
        switch intoSocket?.keypath as? String {
        case #keyPath(Vehicleprofile.turret): turret = pin as? VehicleprofileTurret
        case #keyPath(Vehicleprofile.suspension): suspension = pin as? VehicleprofileSuspension
        case #keyPath(Vehicleprofile.radio): radio = pin as? VehicleprofileRadio
        case #keyPath(Vehicleprofile.gun): gun = pin as? VehicleprofileGun
        case #keyPath(Vehicleprofile.engine): engine = pin as? VehicleprofileEngine
        case #keyPath(Vehicleprofile.ammo): ammo = pin as? VehicleprofileAmmoList
        case #keyPath(Vehicleprofile.armor): armor = pin as? VehicleprofileArmorList
        case #keyPath(Vehicleprofile.modules): modules = pin as? VehicleprofileModule
        default: assertionFailure("undefiend field \(String(describing: socket))")
        }
        // swiftlint:enable cyclomatic_complexity
    }

    public func plug(pins _: [ManagedObjectPinProtocol]?, intoSocket _: JointSocketProtocol?) {
        //
    }
}
