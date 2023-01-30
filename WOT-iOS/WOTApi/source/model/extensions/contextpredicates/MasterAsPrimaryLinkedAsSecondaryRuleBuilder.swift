//
//  MasterAsPrimaryLinkedAsSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

/** Creates predicate

 modulesTree module:     default_profile.vehicles.tank_id == 1073 AND module_id == 1332

 modulesTree nextModule: default_profile.vehicles.tank_id == 1073 and module_id == 1330

 */
open class MasterAsPrimaryLinkedAsSecondaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol) {
        self.pin = pin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        var parentJSONRefs = [JSONRefProtocol]()
        if let parentJson = pin.contextPredicate?.jsonRefs {
            parentJSONRefs.append(contentsOf: parentJson)
        }

        let lookupPredicate = ContextPredicate(jsonRefs: parentJSONRefs)
        lookupPredicate[.primary] = pin.contextPredicate?[.primary]
        lookupPredicate[.secondary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)

        return lookupPredicate
    }
}
