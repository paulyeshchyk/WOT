//
//  ModulesTreeModule_Composer.swift
//  WOTApi
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - ModulesTreeModule_Composer

/** Creates predicate

 modulesTree currentModule: default_profile.vehicles.tank_id == 1073 AND module_id == 1076

 modulesTree module:        default_profile.vehicles.tank_id == 1073 AND module_id == 1332

 modulesTree nextModule:    default_profile.vehicles.tank_id == 1073 and module_id == 1330

 */
open class ModulesTreeModule_Composer: CustomStringConvertible, ComposerProtocol {

    public var description: String {
        "[\(type(of: self))]"
    }

    // MARK: Public

    public func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol {
        guard let pin = composerInput.pin else {
            throw ModulesTreeModule_ComposerError.pinNotFound
        }

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

// MARK: - %t + ModulesTreeModule_Composer.ModulesTreeModule_ComposerError

extension ModulesTreeModule_Composer {
    enum ModulesTreeModule_ComposerError: Error {
        case pinNotFound
    }
}
