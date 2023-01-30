//
//  VehicleprofileAmmoList_Composer.swift
//  WOTApi
//
//  Created by Paul on 30.12.22.
//
//

// MARK: - VehicleprofileAmmoList_Composer

/** Creates predicate

 vehicleProfileAmmoList ammoDamage:      vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND type == "ARMOR_PIERCING"

 vehicleProfileAmmoList ammoPenetration: vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND type == "HIGH_EXPLOSIVE"

 */
public class VehicleprofileAmmoList_Composer: CustomStringConvertible, ComposerProtocol {

    public var description: String {
        "[\(type(of: self))]"
    }

    // MARK: Public

    public func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol {
        guard let pin = composerInput.pin else {
            throw VehicleprofileAmmoList_ComposerError.pinNotFound
        }

        guard let parentKey = composerInput.parentKey else {
            throw VehicleprofileAmmoList_ComposerError.parentKeyNotFound
        }

        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]?.foreignKey(byInsertingComponent: parentKey)
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .internal, andObject: pin.identifier)

        return lookupPredicate
    }
}

// MARK: - %t + VehicleprofileAmmoList_Composer.VehicleprofileAmmoList_ComposerError

extension VehicleprofileAmmoList_Composer {
    enum VehicleprofileAmmoList_ComposerError: Error {
        case pinNotFound
        case parentKeyNotFound
    }
}
