//
//  VehicleprofileAmmo_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - VehicleprofileAmmo_Composer

/** Creates predicate

 vehicleprofileammo damage:      vehicleprofileAmmo.vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND vehicleprofileAmmo.type == "HIGH_EXPLOSIVE"

 vehicleprofileammo penetration: vehicleprofileAmmo.vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND vehicleprofileAmmo.type == "ARMOR_PIERCING_CR"

 */
public class VehicleprofileAmmo_Composer: CustomStringConvertible, ComposerProtocol {

    public var description: String {
        "[\(type(of: self))]"
    }

    // MARK: Public

    public func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol {
        guard let pin = composerInput.pin else {
            throw VehicleprofileAmmo_ComposerError.pinNotFound
        }
        guard let parentKey = composerInput.parentKey else {
            throw VehicleprofileAmmo_ComposerError.parentKeyNotFound
        }

        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]?.foreignKey(byInsertingComponent: parentKey)
        lookupPredicate[.secondary] = pin.contextPredicate?[.secondary]?.foreignKey(byInsertingComponent: parentKey)

        return lookupPredicate
    }
}

// MARK: - %t + VehicleprofileAmmo_Composer.VehicleprofileAmmo_ComposerError

extension VehicleprofileAmmo_Composer {
    enum VehicleprofileAmmo_ComposerError: Error {
        case parentKeyNotFound
        case pinNotFound
    }
}
