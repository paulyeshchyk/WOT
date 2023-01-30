//
//  PrimaryKey_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

/** Creates predicate

 treeview:                  tank_id == 1073

 modulesTree nextTank:      tank_id == 2353

 vehicleProfile engine:     tag == "_Type_102S"

 vehicleProfile gun:        tag == "_85mm_S-53"

 vehicleProfile suspension: tag == "Chassis_Ch04_T34_1"

 vehicleProfile turret:     tag == "Turret_1_Ch04_T34_1"

 vehicleProfile radio:      tag == "A-220_1"

 */
open class PrimaryKey_Composer: FetchRequestPredicateComposerProtocol {

    private let pin: JointPinProtocol

    // MARK: Lifecycle

    public init(pin: JointPinProtocol) {
        self.pin = pin
    }

    // MARK: Public

    public func buildRequestPredicateComposition() throws -> ContextPredicateProtocol {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .internal, andObject: pin.identifier)

        return lookupPredicate
    }
}
