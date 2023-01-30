//
//  VehicleprofileAmmo_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

/** Creates predicate

 vehicleprofileammo damage:      vehicleprofileAmmo.vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND vehicleprofileAmmo.type == "HIGH_EXPLOSIVE"

 vehicleprofileammo penetration: vehicleprofileAmmo.vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND vehicleprofileAmmo.type == "ARMOR_PIERCING_CR"

 */
public class VehicleprofileAmmo_Composer: FetchRequestPredicateComposerProtocol {

    private var pin: JointPinProtocol
    private var parentKey: String

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, parentKey: String) {
        self.pin = pin
        self.parentKey = parentKey
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]?.foreignKey(byInsertingComponent: parentKey)
        lookupPredicate[.secondary] = pin.contextPredicate?[.secondary]?.foreignKey(byInsertingComponent: parentKey)

        return lookupPredicate
    }
}
