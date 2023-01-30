//
//  VehicleprofileAmmoListAmmoRequestPredicateComposer.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//
//

/** Creates predicate

 vehicleProfileAmmoList ammoDamage:      vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND type == "ARMOR_PIERCING"

 vehicleProfileAmmoList ammoPenetration: vehicleprofileAmmoList.vehicleprofile.vehicles.tank_id == 1073 AND type == "HIGH_EXPLOSIVE"

 */
public class VehicleprofileAmmoListAmmoRequestPredicateComposer: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private var foreignSelectKey: String

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, foreignSelectKey: String) {
        self.pin = pin
        self.foreignSelectKey = foreignSelectKey
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .internal, andObject: pin.identifier)

        return lookupPredicate
    }
}
