//
//  PrimaryKey_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - PrimaryKey_Composer

/** Creates predicate

 treeview:                  tank_id == 1073

 modulesTree nextTank:      tank_id == 2353

 vehicleProfile engine:     tag == "_Type_102S"

 vehicleProfile gun:        tag == "_85mm_S-53"

 vehicleProfile suspension: tag == "Chassis_Ch04_T34_1"

 vehicleProfile turret:     tag == "Turret_1_Ch04_T34_1"

 vehicleProfile radio:      tag == "A-220_1"

 */
open class PrimaryKey_Composer: CustomStringConvertible, ComposerProtocol {

    public var description: String {
        "[\(type(of: self))]"
    }

    // MARK: Public

    public func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol {
        guard let pin = composerInput.pin else {
            throw PrimaryKey_ComposerError.pinNotFound
        }
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .internal, andObject: pin.identifier)

        return lookupPredicate
    }
}

// MARK: - %t + PrimaryKey_Composer.PrimaryKey_ComposerError

extension PrimaryKey_Composer {
    enum PrimaryKey_ComposerError: Error {
        case pinNotFound
    }
}
