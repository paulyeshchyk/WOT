//
//  ForeignKeyRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

open class ForeignAsPrimaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private var foreignSelectKey: String
    private let jsonRefs: [JSONRefProtocol]
    private let jsonMap: JSONMapProtocol

    // MARK: Lifecycle

    public init(jsonMap: JSONMapProtocol, foreignSelectKey: String, jsonRefs: [JSONRefProtocol]) {
        self.foreignSelectKey = foreignSelectKey
        self.jsonRefs = jsonRefs
        self.jsonMap = jsonMap
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate(jsonRefs: jsonRefs)
        lookupPredicate[.primary] = jsonMap.contextPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)
        /*
         defaultProfile: vehicles.tank_id == 1073
         vehicleprofile.ammolist, vehicleprofile.armorlist, vehicleprofile.module: vehicleprofile.vehicles.tank_id == 1073
         vehicleprofileArmorlist.armor: vehicleprofileArmorListTurret.vehicleprofile.vehicles.tank_id == 1073
         vehicleprofileArmorlist.armor: vehicleprofileArmorListHull.vehicleprofile.vehicles.tank_id == 1073
          */
        return lookupPredicate
    }
}
