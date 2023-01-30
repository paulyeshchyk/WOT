//
//  VehicleprofileModule_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - VehicleprofileModule_Composer

/** Creates predicate

 vehicleProfileModule gun:        vehicleprofile.vehicles.tank_id == 1073 AND gun_id == 820

 vehicleProfileModule radio:      vehicleprofile.vehicles.tank_id == 1073 AND radio_id == 823

 vehicleProfileModule engine:     vehicleprofile.vehicles.tank_id == 1073 AND engine_id == 1589

 vehicleProfileModule suspension: vehicleprofile.vehicles.tank_id == 1073 AND suspension_id == 1074

 vehicleProfileModule turret:     vehicleprofile.vehicles.tank_id == 1073 AND turret_id == 1075

 */
open class VehicleprofileModule_Composer: CustomStringConvertible, ComposerProtocol {

    public var description: String {
        "[\(type(of: self))]"
    }

    // MARK: Public

    public func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol {
        guard let pin = composerInput.pin else {
            throw VehicleprofileModule_ComposerError.pinNotFound
        }
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)
        lookupPredicate[.secondary] = pin.contextPredicate?[.primary]

        return lookupPredicate
    }
}

// MARK: - %t + VehicleprofileModule_Composer.VehicleprofileModule_ComposerError

extension VehicleprofileModule_Composer {
    enum VehicleprofileModule_ComposerError: Error {
        case pinNotFound
    }
}
