//
//  ForeignKey_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - ForeignKey_Composer

/** Creates predicate

 vehicle defaultprofile: vehicles.tank_id == 4657

 profile ammolist:       vehicleprofile.vehicles.tank_id == 4657

 profile armorlist:      vehicleprofile.vehicles.tank_id == 4657

 profile module:         vehicleprofile.vehicles.tank_id == 4657

 armorlist turret:       vehicleprofileArmorListTurret.vehicleprofile.vehicles.tank_id == 4657

 armorlist hull:         vehicleprofileArmorListHull.vehicleprofile.vehicles.tank_id == 4657

 */
open class ForeignKey_Composer: CustomStringConvertible, ComposerProtocol {

    public var description: String {
        "[\(type(of: self))]"
    }

    // MARK: Public

    public func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol {
        guard let parentKey = composerInput.parentKey else {
            throw ForeignKey_ComposerError.parentKeyNotFound
        }
        guard let parentJsonRefs = composerInput.parentJSONRefs else {
            throw ForeignKey_ComposerError.parentJSonRefsNotFound
        }
        guard let contextPredicate = composerInput.contextPredicate else {
            throw ForeignKey_ComposerError.contextPredicateNotFound
        }

        let lookupPredicate = ContextPredicate(jsonRefs: parentJsonRefs)
        lookupPredicate[.primary] = contextPredicate[.primary]?.foreignKey(byInsertingComponent: parentKey)

        return lookupPredicate
    }
}

// MARK: - %t + ForeignKey_Composer.ForeignKey_ComposerError

extension ForeignKey_Composer {
    enum ForeignKey_ComposerError: Error {
        case parentKeyNotFound
        case contextPredicateNotFound
        case parentJSonRefsNotFound
    }
}
