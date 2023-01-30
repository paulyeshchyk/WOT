//
//  MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

/** Creates predicate

 module gun:     tank_id == 1073 AND gun_id == 820

 module chassis: tank_id == 1073 AND suspension_id == 1330

 module radio:   tank_id == 1073 AND radio_id == 567

 module engine:  tank_id == 1073 AND engine_id == 1589

 module turret:  tank_id == 1073 AND turret_id == 1075

 */
public class MasterIDAsSecondaryLinkedAsPrimaryRuleBuilder: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol
    private let parentHostPin: JointPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol, parentHostPin: JointPinProtocol) {
        self.pin = pin
        self.parentHostPin = parentHostPin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)
        lookupPredicate[.secondary] = parentHostPin.modelClass.primaryKey(forType: .internal, andObject: parentHostPin.identifier)

        return lookupPredicate
    }
}
