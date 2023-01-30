//
//  VehicleprofileModule_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

/** Creates predicate

 vehicleProfileModule gun:        vehicleprofile.vehicles.tank_id == 1073 AND gun_id == 820

 vehicleProfileModule radio:      vehicleprofile.vehicles.tank_id == 1073 AND radio_id == 823

 vehicleProfileModule engine:     vehicleprofile.vehicles.tank_id == 1073 AND engine_id == 1589

 vehicleProfileModule suspension: vehicleprofile.vehicles.tank_id == 1073 AND suspension_id == 1074

 vehicleProfileModule turret:     vehicleprofile.vehicles.tank_id == 1073 AND turret_id == 1075

 */
open class VehicleprofileModule_Composer: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol) {
        self.pin = pin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)
        lookupPredicate[.secondary] = pin.contextPredicate?[.primary]

        return lookupPredicate
    }
}
