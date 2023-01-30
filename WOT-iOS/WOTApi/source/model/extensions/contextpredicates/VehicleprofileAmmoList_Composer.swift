//
//  VehicleprofileAmmoList_Composer.swift
//  WOTApi
//
//  Created by Paul on 30.12.22.
//
//

/** Creates predicate

 vehicleProfileAmmoList ammoDamage:      vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND type == "ARMOR_PIERCING"

 vehicleProfileAmmoList ammoPenetration: vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND type == "HIGH_EXPLOSIVE"

 */
public class VehicleprofileAmmoList_Composer: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
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
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .internal, andObject: pin.identifier)

        return lookupPredicate
    }
}
