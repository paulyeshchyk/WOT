//
//  Module_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - Module_Composer

/** Creates predicate

 module gun:     tank_id == 1073 AND gun_id == 820

 module chassis: tank_id == 1073 AND suspension_id == 1330

 module radio:   tank_id == 1073 AND radio_id == 567

 module engine:  tank_id == 1073 AND engine_id == 1589

 module turret:  tank_id == 1073 AND turret_id == 1075

 */
public class Module_Composer: CustomStringConvertible, ComposerProtocol {

    public var description: String {
        "[\(type(of: self))]"
    }

    // MARK: Public

    public func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol {
        guard let pin = composerInput.pin else {
            throw Module_ComposerError.pinNotFound
        }
        guard let parentPin = composerInput.parentPin else {
            throw Module_ComposerError.parentPinNotFound
        }
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = pin.modelClass.primaryKey(forType: .external, andObject: pin.identifier)
        lookupPredicate[.secondary] = parentPin.modelClass.primaryKey(forType: .internal, andObject: parentPin.identifier)

        return lookupPredicate
    }
}

// MARK: - %t + Module_Composer.Module_ComposerError

extension Module_Composer {
    enum Module_ComposerError: Error {
        case pinNotFound
        case parentPinNotFound
    }
}
