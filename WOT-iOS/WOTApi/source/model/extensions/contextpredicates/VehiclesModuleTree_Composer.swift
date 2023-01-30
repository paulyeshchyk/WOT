//
//  VehiclesModuleTree_Composer.swift
//  WOTApi
//
//  Created by Paul on 13.01.23.
//

// MARK: - VehiclesModuleTree_Composer

/** Creates predicate

 vehicle moduleTree: default_profile.vehicles.tank_id == 1073

 */
public class VehiclesModuleTree_Composer: CustomStringConvertible, ComposerProtocol {

    public var description: String {
        "[\(type(of: self))]"
    }

    public func build(_ composerInput: ComposerInputProtocol) throws -> ContextPredicateProtocol {
        guard let parentContextPredicate = composerInput.parentContextPredicate else {
            throw VehiclesModuleTree_ComposerError.parentContextPredicateNotFound
        }
        guard let parentJSONRefs = composerInput.parentJSONRefs else {
            throw VehiclesModuleTree_ComposerError.parentJSONRefsNotFound
        }

        let lookupPredicate = ContextPredicate(jsonRefs: parentJSONRefs)
        lookupPredicate[.primary] = parentContextPredicate[.primary]?
            .foreignKey(byInsertingComponent: #keyPath(Vehicleprofile.vehicles))?
            .foreignKey(byInsertingComponent: #keyPath(ModulesTree.default_profile))

        return lookupPredicate
    }
}

// MARK: - %t + VehiclesModuleTree_Composer.VehiclesModuleTree_ComposerError

extension VehiclesModuleTree_Composer {
    enum VehiclesModuleTree_ComposerError: Error {
        case parentContextPredicateNotFound
        case parentJSONRefsNotFound
    }
}
