//
//  ForeignKeyRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

/** Creates predicate

 vehicle defaultprofile: vehicles.tank_id == 4657

 profile ammolist:       vehicleprofile.vehicles.tank_id == 4657

 profile armorlist:      vehicleprofile.vehicles.tank_id == 4657

 profile module:         vehicleprofile.vehicles.tank_id == 4657

 armorlist turret:       vehicleprofileArmorListTurret.vehicleprofile.vehicles.tank_id == 4657

 armorlist hull:         vehicleprofileArmorListHull.vehicleprofile.vehicles.tank_id == 4657

 */
open class ForeignAsPrimaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private var foreignSelectKey: String
    private let jsonRefs: [JSONRefProtocol]
    private let contextPredicate: ContextPredicateProtocol

    // MARK: Lifecycle

    public init(contextPredicate: ContextPredicateProtocol, foreignSelectKey: String, jsonRefs: [JSONRefProtocol]) {
        self.foreignSelectKey = foreignSelectKey
        self.jsonRefs = jsonRefs
        self.contextPredicate = contextPredicate
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate(jsonRefs: jsonRefs)
        lookupPredicate[.primary] = contextPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)

        return lookupPredicate
    }
}
